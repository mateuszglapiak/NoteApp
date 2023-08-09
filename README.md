# NoteApp

# Project structure

 * Views - This directory contains all the view logic written in SwiftUI.
 * Models - This directory includes the data models.
 * Managers - This directory encapsulates the logic for managing the context of notes and networking, which covers both REST and WebSockets.

# Design

The main purpose of the application is to allow users to add notes, share them between devices, and edit them in real time.

It features three main views:
* Connecting to the Server
* List of Notes, where users can:
    * Add notes
    * Filter notes
    * Remove notes
    * Share notes
* Edit View, where users can edit the title and content in real time with other users.

# Architecture

# REST API:        

### Get all notes

`GET {server}/api/notes`        

### Get a specific note by ID

`GET {server}/api/notes/{id}`

### Create a new note

`POST {server}/api/notes`

#### Body
```
title: String
content: String
access: [String]
owner: String
```
### Update a note by ID

`PUT {server}/api/notes/{id}`

#### Body
```
title: String
content: String
access: [String]
owner: String
```
### Delete a note by ID

`DELETE {server}/api/notes/{id}`

# WebSocket:

To streamline implementation, we've chosen to utilize a broadcast messaging approach. For simplified communication, all messages are transformed into a standardized format called `WSObject`.

#### Model:
```
class WSObject {
    method   - method
    id       - an ID of the note
    deviceId - an ID of the device
}
```

This `WSObject` class encapsulates essential information for each message, including the method, note ID, and device ID. This standardized format ensures a straightforward and consistent messaging process throughout the application.

#### Receive:
    Message -> String -> JSON -> WSObject

#### Send: 
    WSObject -> JSON -> String -> Message

# iOS:

#### Context:

 * This is the data model object responsible for storing notes.

#### Context Manager:

* Manages actions related to notes, including creation, addition, editing, deletion, and sharing.
* Responsible for communicating with the Network Manager.
* Responsible for communicating with Views.

#### Network Manager:

* Handles communication with the REST backend server.
* Communicates with the WebSocket Manager, passing messages to the Context Manager.

#### WebSocket Manager:

* Manages communication with the WebSocket server.
* Converts messages into WSObjects, the standardized message format.

# Technology

### Backend:

* Server: Built using express.js with integrated ws for WebSocket support.
* Database: Utilizes MongoDB for data storage.

### Frontend:

* Platform: Developed for iOS devices.
* Languages: Implemented using Swift and SwiftUI for the user interface.

# Deployment Instructions:

### Requirements:

* `MongoDB`
* `npm`
* `Xcode`
  
### Server:

1. Navigate to the server folder: `cd ./Server`
2. Install dependencies: `npm install`
3. Launch the server: `node app.js`
   
### iOS:

1. Navigate to the iOS folder.
2. Open `NoteApp.xcodeproj` in Xcode.
3. Select `Product -> Run` to initiate the iOS application.

# Features

1. **Connect to Server:** Users can establish a connection from their device by specifying either a localhost or an IP address.

2. **Add Note:** Users can effortlessly add a note by tapping the button located in the bottom right corner.

3. **Delete Note:** Deleting notes is made easy. Users can tap the Edit button and then select the notes they want to delete.

4. **Unlock Note:** To unlock a note, users can perform a long tap on the lock image. This action sends a message to the owner, who must be online to respond.

5. **Filter Notes:** Users have the flexibility to filter the list of notes by selecting from categories such as All, Locked, and Unlocked.

6. **Edit Note:** For unlocked notes, users can seamlessly edit both the title and content.

### Future improvements:

In the existing implementation, WebSockets are transmitted using a broadcast mode, resulting in an increase in the number of calls and messages with each user. An enhancement could be readily achieved by transmitting targeted messages to individual devices or users. This improvement would optimize communication efficiency and reduce unnecessary overhead.

### Scalability:

The context object has been designed with scalability in mind. The integration of the ContextManager ensures the adaptability of all views. By utilizing the ContextManager, changes to the context can be seamlessly implemented, and all associated views will automatically adjust accordingly.

Thanks to the current implementation, the ability to swap contexts is also feasible. This flexibility allows for dynamic adjustments in response to evolving requirements, enabling a smoother and more efficient user experience.
