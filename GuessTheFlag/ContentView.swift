//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anatoliy Petrov on 7.12.22..
//rgb(241, 224, 172)

import SwiftUI

struct YellowText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.init(red: 241/255, green: 224/255, blue: 172/255))
        
    }
}

extension View {
    func yellowTexted() -> some View {
        modifier(YellowText())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreCount = 0
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 116/255, green: 149/255, blue: 154/255), location: 0.3),
                .init(color: Color(red: 73/255, green: 83/255, blue: 113/255), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .yellowTexted()
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                                .shadow(radius: 100)
                        }
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Your score is \(scoreCount) points")
                    .font(.title.bold())
                    .padding(.vertical, 20)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(scoreCount) ")
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            scoreCount += 1
        } else {
            scoreTitle = "Maybe next time :("
        }
        
        showingScore = true
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
