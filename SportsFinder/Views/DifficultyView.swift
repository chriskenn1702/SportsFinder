//
//  DifficultyView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/24/23.
//

import SwiftUI

struct DifficultyView: View {
    @Binding var rating: Int
    @State var interactive = true
    let highestRating = 5
    let unselected = Image(systemName: "trophy")
    let selected = Image(systemName: "trophy.fill")
    var font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack{
            ForEach(1...highestRating, id: \.self) { number in
                showImage(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        if interactive{
                            rating = number
                        }
                    }
            }
            .font(font)
        }
    }
    func showImage( for number: Int) -> Image{
        if number>rating{
            return unselected
        } else{
            return selected
        }
    }
}

struct StarsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyView(rating: .constant(3))
    }
}
