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

enum ElementType{
    case Field
    case Border
    case Fill
    case FillPre
}

class DrawingModel: NSObject {
    init(withRows rows:Int, andCols cols:Int) {
        NumberOfRows = rows
        NumberOfCols = cols
        Grid = Array(repeating: Array(repeating: ElementType.Field, count: cols), count: rows)
    }
    let NumberOfRows: Int
    let NumberOfCols: Int
    var Grid: Array<[ElementType]>
}
