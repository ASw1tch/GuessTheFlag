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
    @State private var animationAmount = 0.0
    
    @State private var animateCorrect = 0.0
    @State private var animateOpacity = 1.0
    @State private var besidesTheCorrect = false
    @State private var besidesTheWrong = false
    @State private var selectedFlag = 0
    
    
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
                            withAnimation(.easeIn(duration: 1.5)) {
                                animationAmount += 360
                            }
                            
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                                .shadow(radius: 100)
                            // Animate the flag when the user tap the correct one:
                            // Rotate the correct flag
                                .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animateCorrect : 0), axis: (x: 1, y: 1, z: 0))
                            // Reduce opacity of the other flags to 25%
                                .opacity(number != self.correctAnswer && self.besidesTheCorrect ? self.animateOpacity : 1)
                            
                            // Animate the flag when the user tap the wrong one:
                            // Create a red background to the wrong flag
                                .background(self.besidesTheWrong && self.selectedFlag == number ? Capsule(style: .circular).fill(Color.red).blur(radius: 50) : Capsule(style: .circular).fill(Color.clear).blur(radius: 0))
                            // Reduce opacity of the other flags to 25% (including the correct one)
                                .opacity(self.besidesTheWrong && self.selectedFlag != number ? self.animateOpacity : 1)
                            
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
        besidesTheCorrect = false
        besidesTheWrong = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            scoreCount += 1
            withAnimation(.interpolatingSpring(stiffness: 7, damping: 7)) {
                self.animateCorrect += 360
                self.animateOpacity = 0.25
                self.besidesTheCorrect = true
            }
        } else {
            scoreTitle = "Maybe next time :("
            withAnimation(.interpolatingSpring(stiffness: 7, damping: 7)) {
                self.animateOpacity = 0.5
                self.besidesTheWrong = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingScore = true
            
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
