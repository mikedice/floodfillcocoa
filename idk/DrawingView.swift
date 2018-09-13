/*
 Flood fill visualized
 Copyright (C) 2018  Mike Dice (mikedice417@hotmail.com)
 http://mikedice.net
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


import Cocoa

class DrawingView: NSView {
    var drawingModel:DrawingModel? = nil
    var opsArray:Array<NSPoint>? = nil
    let EmptyCellColor:NSColor = NSColor.blue
    let BorderColor:NSColor = NSColor.green
    let FillColor:NSColor = NSColor.yellow
    
    func animateFill(opsArray:inout Array<NSPoint>){
        self.opsArray = opsArray
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
            
            if(self.opsArray!.count > 0){
                let pt:NSPoint = self.opsArray!.removeFirst()
                self.drawingModel!.Grid[Int(pt.x)][Int(pt.y)] = ElementType.Fill
                self.needsDisplay = true
            }
            else{
                timer.invalidate()
                self.opsArray = nil
            }
        }
    }
    
    // The controller updated the model
    // so refresh the view
    func update(viewModel: DrawingModel)
    {
        self.drawingModel = viewModel
        self.needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Fill in the background
        let fillColor = NSColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
        fillColor.set()
        let bPath:NSBezierPath = NSBezierPath(rect: self.bounds)
        bPath.fill()
        
        if self.drawingModel != nil {
            // Draw some little yellow boxes
            var x = 10
            var y = 10
            for r in 0...drawingModel!.NumberOfRows-1
            {
                for c in 0...drawingModel!.NumberOfCols-1
                {
                    switch drawingModel!.Grid[r][c]{
                        case .Border:
                            BorderColor.set()
                        case .Field:
                            EmptyCellColor.set()
                        case.Fill:
                            FillColor.set()
                        case.FillPre:
                            EmptyCellColor.set()
                    }
                    
                    let drawRect = NSRect(x: x, y: y, width: 10, height: 10)
                    let smallRect:NSBezierPath = NSBezierPath(rect:drawRect);
                    smallRect.fill()
                    
                    x += 10 + 5
                }
                x = 10
                y += 10 + 5
            }
        }
    }
    
    // Flipping the coordinate system so my head doesn't explode
    override var isFlipped:Bool {
        get {
            return true
        }
    }
}
