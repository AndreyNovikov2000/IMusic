//
//  Library.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.saveTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    var tabBarDelegate: MainTabBarDelegate?
    
    var body: some View {
        VStack {
            GeometryReader { geomentry in
                HStack(alignment: .center) {
                    Button(action: {
                        
                        self.track = self.tracks[0]
                        self.tabBarDelegate?.maximazeTrackDetailView(withViewModel: self.track)
                        
                    }, label: {
                        Image(systemName: "play.fill")
                    })
                        .frame(width: geomentry.size.width / 2 - 20, height: 50)
                        .accentColor(Color(#colorLiteral(red: 1, green: 0.2415002286, blue: 0.6340380311, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                    
                    Button(action: {
                        
                        self.tracks = UserDefaults.standard.saveTracks()
                        
                    }, label: {
                        Image(systemName: "arrow.2.circlepath")
                    })
                        .frame(width: geomentry.size.width / 2 - 20, height: 50)
                        .accentColor(Color(#colorLiteral(red: 1, green: 0.2415002286, blue: 0.6340380311, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                    
                }.padding()
            }
            .frame(height: 50)
            
            Divider()
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            List {
                ForEach(tracks) { track in
                    LibraryCellCell(cell: track)
                        .gesture(
                            
                            LongPressGesture()
                                .onEnded{ _ in
                                    self.track = track
                                    self.showingAlert = true
                            }
                            .simultaneously(with:
                                
                                TapGesture()
                                    .onEnded { _ in
                                        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
                                        
                                        let tabbarVC = keyWindow?.rootViewController as? MainTabBarController
                                        tabbarVC?.trackDetailView.myDelegate = self
                                        
                                        self.track = track
                                        self.tabBarDelegate?.maximazeTrackDetailView(withViewModel: self.track)
                            }))
                    
                }.onDelete(perform: delete(at:))
            }
            
        }.actionSheet(isPresented: $showingAlert) { () -> ActionSheet in
            ActionSheet(title: Text("Do you want to delete this track?"), buttons: [
                .destructive(Text("Delete"), action: {
                    self.delete(track: self.track)
                }),
                .cancel()
            ])
        }
    }
}

extension Library {
    
    func delete(at offSets: IndexSet) {
        tracks.remove(atOffsets: offSets)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(savedData, forKey: UserDefaults.tracksKey)
        }
    }
    
    
    func delete(track: SearchViewModel.Cell) {
        guard let index = tracks.firstIndex(of: track) else { return }
        tracks.remove(at: index)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(savedData, forKey: UserDefaults.tracksKey)
        }
    }
}

struct LibraryCellCell: View {
    
    var cell: SearchViewModel.Cell
    
    var url: URL {
        return URL(string: cell.iconUrlString!)!
    }
    
    var body: some View {
        HStack(alignment: .center) {
            URLImage(url) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 60, height: 60, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(cell.trackName)
                Text(cell.artistName)
            }
            .padding(.leading, 16)
        }
        .padding(.leading, 10)
    }
}


// MARK: - TrackDetailViewDelegate

extension Library: TrackDetailViewDelegate {
    func trackDetailViewGetPreviousTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell? {
        guard let index = tracks.firstIndex(of: track) else { return nil }
        let previusTrack: SearchViewModel.Cell
        
        if index == 0 {
            previusTrack = tracks[tracks.count - 1]
        } else {
            previusTrack = tracks[index - 1]
        }
        
        return previusTrack
    }
    
    func trackDetailViewGetNextTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell? {
        guard let index = tracks.firstIndex(of: track) else { return nil }
        let nextTrack: SearchViewModel.Cell
        
        if index == tracks.count - 1 {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[index + 1]
        }
        
        self.track = nextTrack
        
        return nextTrack
        
    }
}
