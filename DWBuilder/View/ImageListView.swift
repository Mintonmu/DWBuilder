//
//  ImageListView.swift
//  DWBuilder
//
//  Created by 张曙 on 2020/8/11.
//

import SwiftUI

struct ImageListView: View {
    @Binding var imageMetadatas: [ImageMetadata]
    @State var selectedIndex: Int? = nil
    
    static let DEFAULT_LATITUDE_POSITION = LatitudePosition.North
    static let DEFAULT_LATITUDE = 30.0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: self.onPlusButtonPressed) {
                    Image(systemName: "plus")
                }
                Button(action: self.onDeleteButtonPressed) {
                    Image(systemName: "minus")
                }
                    .disabled(self.selectedIndex == nil)
            }
            if self.imageMetadatas.isEmpty {
                Text("Please click the above button to add some images")
            } else {
                List(selection: self.$selectedIndex) {
                    ForEach(self.imageMetadatas.indices, id: \.self) { index in
                        ImageRowView(imageMetadata: self.$imageMetadatas[index])
                            .frame(maxWidth: .infinity)
                    }
                        .onDelete(perform: { indexSet in
                            self.imageMetadatas.remove(atOffsets: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            self.imageMetadatas.move(fromOffsets: indices, toOffset: newOffset)
                        })
                }
            }
        }
    }
    
    func onPlusButtonPressed() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = true
        
        if openPanel.runModal() == .OK {
            let addedImageMetadatas = openPanel.urls.map { url in
                ImageMetadata(url: url, latitudePosition: Self.DEFAULT_LATITUDE_POSITION, latitude: Self.DEFAULT_LATITUDE, date: Date())
            }
            self.imageMetadatas.append(contentsOf: addedImageMetadatas)
        }
    }
    
    func onDeleteButtonPressed() {
        guard let selectedIndex = self.selectedIndex else { return }
        self.imageMetadatas.remove(at: selectedIndex)
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ImageListView(imageMetadatas: .constant([
            ImageMetadata(url: URL(fileURLWithPath: "abc"), latitudePosition: .North, latitude: 30.0, date: Date()),
            ImageMetadata(url: URL(fileURLWithPath: "def"), latitudePosition: .North, latitude: 30.0, date: Date()),
            ImageMetadata(url: URL(fileURLWithPath: "ghi"), latitudePosition: .North, latitude: 30.0, date: Date()),
            ImageMetadata(url: URL(fileURLWithPath: "abcabcacbasdoeuasdef"), latitudePosition: .North, latitude: 30.0, date: Date())
        ]))
    }
}
