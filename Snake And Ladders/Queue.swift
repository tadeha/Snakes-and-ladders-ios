//
//  Queue.swift
//  Snake And Ladders
//
//  Created by Tadeh Alexani on 10/11/1396 AP.
//  Copyright © 1396 Tadeh Alexani. All rights reserved.
//

public struct Queue<T> {
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public var count: Int {
        return list.count
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return list.remove(at: 0)
        }
    }
    
    public var front: T? {
        return list.first
    }
    
}
