const express = require('express');
const { MongoClient, ObjectId } = require('mongodb');
const WebSocket = require('ws');

const app = express();
const port = 3000;
const ws_port = 3001;

// Middleware to parse incoming JSON data
app.use(express.json());

const mongoUrl = 'mongodb://localhost:27017';
const websocketUrl = 'wss://localhost:'
const dbName = 'notesDatabase';

// Connect to MongoDB
MongoClient.connect(mongoUrl, { useUnifiedTopology: true })
.then(client => {
    const db = client.db(dbName);
    
    // Create the 'notes' collection if it doesn't exist
    db.createCollection('notes').catch(err => {
      if (err.codeName !== 'NamespaceExists') {
        console.error('Error creating collection:', err);
      }
    });
    
    const notesCollection = db.collection('notes');
    
    // WebSocket server
    const wss = new WebSocket.Server({ server: app.listen(ws_port, () => {
        console.log(`WS: Server is running on ws://localhost:${ws_port}`);
    }) });
    
    // Broadcast function to send data to all connected clients
    const broadcast = data => {
        wss.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(data);
            }
        });
    };
    
    // WebSocket connection event
    wss.on('connection', ws => {
        console.log('Client connected');
        
        // WebSocket message event
        ws.on('message', async message => {
            console.log('Received:', JSON.parse(message));
            try {
                broadcast(JSON.stringify(JSON.parse(message)))
            } catch (error) {
                console.error('Error handling message:', error);
            }
        });
        
        // WebSocket close event
        ws.on('close', () => {
            console.log('Client disconnected');
        });
    });
    
    // Route to get all notes
    app.get('/api/notes', async (req, res) => {
        console.log('Get Notes - Success')
        const notes = await notesCollection.find().toArray();
        res.json(notes);
    });
    
    // Route to get a specific note by ID
    app.get('/api/notes/:id', async (req, res) => {
        const noteId = req.params.id;
        const note = await notesCollection.findOne({ _id: new ObjectId(noteId) });
        
        if (!note) {
            return res.status(404).json({ message: 'Note not found.' });
        }
        
        res.json(note);
    });
    
    // Route to create a new note
    app.post('/api/notes', async (req, res) => {
        const { title, content, access, owner } = req.body;
        const newNote = { title, content, access, owner };
        console.log(`Got note:   ${newNote.title}, ${newNote.content}`);
        try {
            const result = await notesCollection.insertOne(newNote);
            console.log('inserted record', result);
            res.status(201).json(result);
            
            // Broadcast the new note to all connected clients
            broadcast(WSObject.jsonFrom("insertOne", result.insertedId, owner));
        } catch (e) {
            res.status(400)
            console.log(e);
        };
    });
    
    // Route to update a note by ID
    app.put('/api/notes/:id', async (req, res) => {
        const noteId = req.params.id;
        const { title, content, access, owner } = req.body;
        const result = await notesCollection.updateOne(
                                                       { _id: new ObjectId(noteId) },
                                                       { $set: { title, content, access, owner } }
                                                       );
        
        if (result.matchedCount === 0) {
            return res.status(404).json({ message: 'Note not found.' });
        }
        
        console.log(`Note updated successfully: ${noteId}`);
        
        res.json({ message: 'Note updated successfully.' });
        
        broadcast(WSObject.jsonFrom("update", noteId, owner));
    });
    
    // Route to delete a note by ID
    app.delete('/api/notes/:id', async (req, res) => {
        const noteId = req.params.id;
        const result = await notesCollection.deleteOne({ _id: new ObjectId(noteId) });
        console.log(`trying to delete: ${noteId}`)
        if (result.deletedCount === 0) {
            return res.status(404).json({ message: 'Note not found.' });
        }
        
        console.log(`Note deleted successfully: ${noteId}`);
        
        res.json({ message: 'Note deleted successfully.' });
        
        broadcast(WSObject.jsonFrom("delete", noteId, ""));
    });
    
    // Start the server
    app.listen(port, () => {
        console.log(`REST: Server is running on http://localhost:${port}`);
    });
})
.catch(err => console.error('Error connecting to MongoDB:', err));

class WSObject {
    constructor(method, id, deviceId) {
        this.method = method;
        this.id = id
        this.deviceId = deviceId
    }
    
    toJson() {
        return JSON.stringify({
            "method": this.method,
            "id": `${this.id}`,
            "deviceId": `${this.deviceId}`
        });
    }
    
    static jsonFrom(method, id, deviceId) {
        return new WSObject(method, id, deviceId).toJson();
    }
}
