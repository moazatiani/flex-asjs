////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.text.html
{
	import org.apache.flex.text.engine.ITextLine;
	import org.apache.flex.text.engine.ITextBlock;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.core.UIBase;
	
	public class TextLine extends UIBase implements ITextLine
	{
		public function TextLine()
		{
		}
		public function get ascent():Number
		{
			return 0;
		}
		
		public function get atomCount():int
		{
			return 0;
		}
		
		public function get blendMode():String
		{
			return null;
		}
		
		public function get cacheAsBitmap():Boolean
		{
			return false;
		}
		
		public function get descent():Number
		{
			return 0;
		}
		
		private var _doubleClickEnabled:Boolean;
		public function get doubleClickEnabled():Boolean
		{
			return _doubleClickEnabled;
		}
		public function set doubleClickEnabled(value:Boolean):void
		{
			_doubleClickEnabled = value;
		}
		
		
		public function get hasGraphicElement():Boolean
		{
			return false;
		}
		
		public function get hasTabs():Boolean
		{
			return false;
		}
		
		public function get metaData():Object
		{
			return null;
		}
		
		public function get nextLine():ITextLine
		{
			return null;
		}
		
		public function get previousLine():ITextLine
		{
			return null;
		}
		
		public function get rawTextLength():int
		{
			return 0;
		}
		
		public function get specifiedWidth():Number
		{
			return 0;
		}
		
		public function get textBlock():ITextBlock
		{
			return null;
		}
		
		public function get textBlockBeginIndex():int
		{
			return 0;
		}
		
		public function get textHeight():Number
		{
			return 0;
		}
		
		public function get textWidth():Number
		{
			return 0;
		}
		
		public function get totalAscent():Number
		{
			return 0;
		}
		
		public function get totalDescent():Number
		{
			return 0;
		}
		
		public function get totalHeight():Number
		{
			return 0;
		}
		
		public function get unjustifiedTextWidth():Number
		{
			return 0;
		}
		
		private var _userData:*;
		public function get userData():*
		{
			return _userData;
		}
		public function set userData(value:*):void
		{
			_userData = value;
		}
		
		private var _validity:String;
		public function get validity():String
		{
			return _validity;
		}
		public function set validity(value:String):void
		{
			_validity = value;
		}
		
		/**
		 * Not sure if we need this.
		 */
		public function dump():String
		{
			return "";
		}

		/**
		 * Gets the bidirectional level of the atom at the specified index.
		 * The FTE system seems to make no sense. Here's the "explanation":
		 *
		 * Gets the bidirectional level of the atom at the specified index. Determined by a combination of TextBlock.bidiLevel
		 * and the Unicode bidirectional properties of the characters that form the line.
		 *
		 * For example, if you start a text block with some Hebrew text, you set TextBlock.bidiLevel to 1, establishing a default of right to left.
		 * If within the text you have a quote in English (left to right), that text has an AtomBidiLevel of 2.
		 * If within the English you have a bit of Arabic (right to left), AtomBidiLevel for that run goes to 3.
		 * If within the Arabic a number (left to right) occurs, the AtomBidiLevel setting for the number is 4.
		 * It does not matter in which line the atoms end up; the Hebrew atoms are AtomBidiLevel 1,
		 * the English atoms are AtomBidiLevel 2, Arabic atoms are AtomBidiLevel 3, and the number atoms are AtomBidiLevel 4.
		 *
		 * After further research. it seems like it's being faithful to the unicode spec which allows up 125 levels of bidi nesting.
		 * Full details here: http://www.unicode.org/reports/tr9/
		 * I'm not sure why this is important from a client perspective. Maybe to properly handle cursor management?
		 * Either way, using it is pretty straight-forward: level % 2 should be 0 for ltr and 1 for rtl.
		 */
		public function getAtomBidiLevel(atomIndex:int):int
		{
			//TODO implement bidi
			return 0;
		}

		public function getAtomBounds(atomIndex:int):Rectangle
		{
			return null;
		}

		public function getAtomCenter(atomIndex:int):Number
		{
			var bounds:Rectangle = getAtomBounds(atomIndex);
			return bounds.left + (bounds.right - bounds.left);
		}

		public function getAtomGraphic(atomIndex:int):IUIBase
		{
			//TODO implement embedded graphics
			return null;
		}

		public function getAtomIndexAtCharIndex(charIndex:int):int
		{
			//TODO track indexes...
			return 0;
		}

		public function getAtomIndexAtPoint(stageX:Number, stageY:Number):int
		{
			//TODO atom locations. This one will be fun...
			return 0;
		}

		public function getAtomTextBlockBeginIndex(atomIndex:int):int
		{
			//TODO track indexes...
			return 0;
		}

		public function getAtomTextBlockEndIndex(atomIndex:int):int
		{
			//TODO track indexes...
			return 0;
		}

		public function getAtomTextRotation(atomIndex:int):String
		{
			//TODO returns TextRotation values.
			return "rotate0";
		}

		public function getAtomWordBoundaryOnLeft(atomIndex:int):Boolean
		{
			//TODO we need to track word boundaries
			return false;
		}

		public function getBaselinePosition(baseline:String):Number
		{
			//TODO baseline is one of TextBaseline, but I'm not sure what the correct value is
			switch(baseline){
				case "ascent":
					break;
				case "descent":
					break;
				case "ideographicBottom":
					break;
				case "ideographicCenter":
					break;
				case "ideographicTop":
					break;
				case "roman":
					break;
				case "useDominantBaseline":
					break;
				default:
					throw new Error("Invalid argument");
			}
			return 0;
		}
	}
}