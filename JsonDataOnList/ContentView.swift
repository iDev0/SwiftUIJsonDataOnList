//
//  ContentView.swift
//  JsonDataOnList
//
//  Created by iDev0 on 2020/03/04.
//  Copyright © 2020 Ju Young Jung. All rights reserved.
//

import SwiftUI

// 프로토콜 확인할것, 모델
struct Todo: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var completed: Bool
}

// 2. 어노테이션 명을 확인하세요 (ObservableObject, ObservedObject)
class FetchTodo: ObservableObject {
    
    @Published var todos = [Todo]()
    
    init() {
        
        // 네트워킹 처리 (Input Your Server Address)
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                if let todoData = data {
                        
                    // 디코더 처리
                    let decodeData = try JSONDecoder().decode([Todo].self, from: todoData)
                    
                    // 메인쓰레드에서 동작되도록 처리
                    DispatchQueue.main.async {
                        self.todos = decodeData
                    }
                    
                } else {
                    print("No Data")
                }
                
            } catch {
                print("Error")
            }
        }.resume()
    }
    
}


struct ContentView: View {
    
    // 2. 어노테이션 명을 확인하세요
    @ObservedObject var fetch = FetchTodo()
    
    var body: some View {
        
        List(fetch.todos) { todo in
            VStack(alignment: .leading) {
                Text(todo.title)
                Text("\(todo.completed.description)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.green)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
