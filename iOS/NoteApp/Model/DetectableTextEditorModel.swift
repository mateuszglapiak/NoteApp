//
//  DetectableTextEditorModel.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI
import Combine

class DetectableTextEditorModel: ObservableObject {
    let detector: PassthroughSubject<Void, Never>
    let publisher: AnyPublisher<Void, Never>
    var onUpdate: (() -> Void)?
    
    init(time: DispatchQueue.SchedulerTimeType.Stride = .seconds(1), onUpdate: (() -> Void)? = nil) {
        detector = PassthroughSubject<Void, Never>()
        publisher = detector
            .debounce(for: time, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
        self.onUpdate = onUpdate
    }
}
