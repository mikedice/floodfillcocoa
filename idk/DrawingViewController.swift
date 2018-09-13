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

class DrawingViewController : NSViewController {
    var model: DrawingModel
    let MAX_COLS:Int = 30
    let MAX_ROWS:Int = 30


    // Outlets and actions made by Interface Builder
    @IBOutlet weak var numColsTextField: NSTextField!
    
    @IBOutlet weak var numRowsTextField: NSTextField!
    
    @IBAction func refreshClicked(_ sender: Any) {
        updateModel()
        self.drawingView.update(viewModel: self.model)
    }
    
    @IBAction func floodFillClicked(_ sender: Any) {
        var opsArray:Array<NSPoint> = Array<NSPoint>()
        fillRectFromPoint(left: 3, top: 3, opsArray: &opsArray)
        self.drawingView.animateFill(opsArray:&opsArray)
        
        
        //self.drawingView.update(viewModel: self.model)
    }
    
    // Helper to update the view model. Collects values from NSTextField
    // controls
    func updateModel()
    {
        var intVal:Int? = readTextFieldValueAsInt(textField:self.numColsTextField)
        let cols:Int = intVal ?? model.NumberOfCols
        
        intVal = readTextFieldValueAsInt(textField:self.numRowsTextField)
        let rows:Int = intVal ?? model.NumberOfRows
        
        self.model = DrawingModel(withRows:rows, andCols:cols)
        
        for r in 0...rows-1{
            for c in 0...cols-1{
                self.model.Grid[r][c] = ElementType.Field
            }
        }
        
        // TODO hard coded rect
        drawRect(left: 1, top: 1, width: 6, height: 6)
    }
    
    func clearGrid(){
        for r in 0...self.model.NumberOfRows-1{
            for c in 0...self.model.NumberOfCols-1{
                self.model.Grid[r][c] = ElementType.Field
            }
        }
    }
    
    func animateFillRect(left:Int, top:Int)
    {
        var ops:Array<NSPoint> = Array<NSPoint>()
        fillRectFromPoint(left: left, top: top, opsArray: &ops)
        
    }
    
    func fillRectFromPoint(left:Int, top:Int, opsArray:inout Array<NSPoint>){
        if (left < 0 || left > self.model.NumberOfCols-1){
            return; // off of one or the other sides
        }
        
        if (top < 0 || top > self.model.NumberOfRows-1){
            return; // off the top or bottom
        }
        
        if (self.model.Grid[top][left] == ElementType.Border)
        {
            return; // encountered a border
        }
        
        if (self.model.Grid[top][left] == ElementType.FillPre){
            return; // already filled
        }
        
        self.model.Grid[top][left] = ElementType.FillPre
        opsArray.append(NSPoint(x: top, y: left))
        
        fillRectFromPoint(left:left+1, top:top, opsArray: &opsArray)
        fillRectFromPoint(left:left-1, top:top, opsArray: &opsArray)
        fillRectFromPoint(left:left, top:top+1, opsArray: &opsArray)
        fillRectFromPoint(left: left, top: top-1, opsArray: &opsArray)
        
        
    }
    
    func drawRect(left:Int, top:Int, width:Int, height:Int){
        for c in left...width {
            self.model.Grid[top][c] = ElementType.Border
        }

        for c in left...width {
            self.model.Grid[top+height-1][c] = ElementType.Border
        }
        
        for r in left...height{
            self.model.Grid[r][left] = ElementType.Border
        }

        for r in left...height{
            self.model.Grid[r][left+width-1] = ElementType.Border
        }
        
        self.model.Grid[3][left+width-1] = ElementType.Field
        self.model.Grid[4][left+width-1] = ElementType.Field
    }
    
    // Helper to read TextField values as an Int
    func readTextFieldValueAsInt(textField:NSTextField) -> Int?
    {
        let fieldValue = Int(textField.stringValue)
        
        if fieldValue != nil && fieldValue! > 0 && fieldValue! <= MAX_COLS
        {
            return fieldValue!
        }
        return nil
    }
    
    // Helper to get properly typed view from myself
    var drawingView: DrawingView
    {
        get
        {
            return self.view as! DrawingView
        }
    }
    
    // Helper to initialize the NSTextField controls in the UI
    func InitializeUITextFields()
    {
        self.numColsTextField.stringValue = String(model.NumberOfCols)
        self.numRowsTextField.stringValue = String(model.NumberOfRows)
    }
    
    func InitializeView()
    {
        clearGrid()
        
        // TODO hard coded rect
        drawRect(left: 1, top: 1, width: 6, height: 6)
        self.drawingView.update(viewModel: self.model)
    }
    
    // Required initializer. Loads and initializes view model
    required init?(coder: NSCoder) {
        self.model = DrawingModel(withRows: 10, andCols: 10)
        super.init(coder:coder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeUITextFields()
        InitializeView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

