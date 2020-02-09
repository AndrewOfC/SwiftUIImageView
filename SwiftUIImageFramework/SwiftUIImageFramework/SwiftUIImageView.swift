//
//  ContentView.swift
//  SwiftImageExe
//
//  Created by ANDREW PAGE on 12/28/19.
//  Copyright © 2019 ANDREW PAGE. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation
import Combine


public struct SwiftUIImageView: View {
  private let uiimage: UIImage ;
  private var image: Image ;
  
  @State var rotated : Bool = true ;
  @State var scale : CGFloat = 1.0 ;
  
  public init(imagepath: String = "testimage.jpg") {
    uiimage = UIImage(imageLiteralResourceName: imagepath) ;
    image = Image(uiImage: uiimage).resizable() ;
  }
  
  /**
     Get the true screen size after rotation
   
    I've observed that the change of he screen size on a
   orientationDidChangeNotification is not reliable.  The
   UIDevice.orientation.isLandscape flag is though
   
    - Returns:  Tuple containing the current screen (width, height)
   
   */
  func trueScreenDimensions() -> (CGFloat, CGFloat) {
    let sh = UIScreen.main.bounds.height ;
    let sw = UIScreen.main.bounds.width ;
    
    if( UIDevice.current.orientation.isLandscape ) {
      if( sw > sh ) {
        return (sw, sh) ;
      }
      else {
        return (sh, sw) ;
      }
    }
    else {
      if( sw > sh ) {
        return (sh, sw) ;
      }
      else {
        return (sw, sh) ;
      }
    }
  }
  
  func setContent() -> some View {
    let (sw, sh) = trueScreenDimensions() ;
    //print("w=\(sw) h=\(sh) scale = \(scale)")
    let (image_w, image_h) = (uiimage.size.width*scale, uiimage.size.height*scale)
    
    let offx = ((image_w)-sw)/2.0 ;
    let offy = ((image_h)-sh)/2.0 ;
    
    
    return image
      .frame(width: image_w, height: image_h)
      .position(x: ((image_w)/2), y: ((image_h)/2))
      .offset(x: offx, y: offy).scaleEffect(scale)
      .gesture(MagnificationGesture()
                 .onChanged { nscale in
                  self.scale = nscale.magnitude }) ;
  }
  
  public var body: some View {
    
    let scrollview =  ScrollView([.vertical, .horizontal], content: self.setContent) ;
    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: UIDevice.current, queue: nil, using: { note in
      self.rotated.toggle();
    })
    
    return scrollview ;
  }
}

struct SwiftUIImageView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIImageView()
    }
}
