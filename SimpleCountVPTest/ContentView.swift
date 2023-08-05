//
//  ContentView.swift
//  SimpleCountVPTest
//
//  Created by Jake Maidment on 25/07/2023.
//



import SwiftUI

struct ContentView: View {
    @State private var circleCount = 1
    @State private var circleColors: [Color] = [.blue] // Initialize with a default color
     
    var body: some View {
        VStack {
            if circleCount <= 5 {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: circleCount), spacing: 16) {
                    ForEach(0..<circleCount, id: \.self) { index in 
                        CircleView(count: $circleCount, circleIndex: index, color: $circleColors[index])
                            .frame(width: 100, height: 100)
                            .transition(.scale)
                    }
                }
                .padding(.bottom, 16)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 5), spacing: 16) {
                    ForEach(0..<circleCount, id: \.self) { index in
                        CircleView(count: $circleCount, circleIndex: index, color: $circleColors[index])
                            .frame(width: 100, height: 100)
                            .transition(.scale)
                    }
                }
                .padding(.bottom, 16)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        if circleCount > 1 {
                            circleCount -= 1
                            circleColors.removeLast() // Remove the color binding when the circle is removed
                        }
                    }
                }, label: {
                    Image(systemName: "minus")
                        .frame(width: 40, height: 40)
                        .font(.title)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 90, height: 20)))
                })
                .frame(width: 40, height: 40)
                .padding()
                
                Button(action: {
                    withAnimation {
                        if circleCount < 15 { // Limit the circle count to 15
                            circleCount = min(circleCount + 1, 15)
                            circleColors.append(.blue) // Add a default color when a new circle is added
                        }
                    }
                }, label: {
                    Image(systemName: "plus")
                        .frame(width: 40, height: 40)
                        .font(.title)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 90, height: 20)))
                    
                })
                .frame(width: 40, height: 40)
                .disabled(circleCount >= 15) // Disable the plus button when there are already 15 circles
                .padding()
                
                Button(action: {
                    withAnimation {
                        resetAllCounts()
                    }
                }, label: {
                    Text("Reset")
                        .frame(width: 90, height: 40)
                        .font(.title)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 90, height: 20)))
                
                })
                .frame(width: 95, height: 30)
                
                Spacer()
            }
        }
        .padding()
    }
    
    private func resetStoredCount(for index: Int) {
        // Reset the stored count for the circle at 'index' to zero
        let key = "count\(index)"
        UserDefaults.standard.setValue(0, forKey: key)
    }
    
    private func resetAllCounts() {
        // Reset all stored counts to zero for the current circle count
        for index in 0..<circleCount {
            resetStoredCount(for: index)
        }
        // Reduce circle count to 1
        circleCount = 1
    }
}

struct CircleView: View {
    @Binding var count: Int
    let circleIndex: Int
    @AppStorage("count") var storedCount: Int = 0
    @Binding var color: Color // Add a binding for color

    init(count: Binding<Int>, circleIndex: Int, color: Binding<Color>) {
        self._count = count
        self.circleIndex = circleIndex
        self._storedCount = AppStorage(wrappedValue: 0, "count\(circleIndex)")
        self._color = color // Initialize the color binding
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color) // Use the color binding here
            Text("\(storedCount)")
                .foregroundColor(.white)
                .font(.title)
            HStack {
                Spacer()
                Button(action: {
                    storedCount -= 1
                }, label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                })
                //.padding(8)
                .background(Color.red.opacity(0.8))
                .clipShape(Circle())
                .offset(x: 26, y: 35)
            }
        }
        .onTapGesture {
            storedCount += 1
        }
        .overlay(
            ColorPicker("Pick a color", selection: $color, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 150, height: 150)
                .padding(10)
                .cornerRadius(20)
                .opacity(0.9)
                .padding(5)
                .offset(x: -40, y: 35) // Change the offset to the opposite side
        )
    }
}



#Preview {
    ContentView()
}
