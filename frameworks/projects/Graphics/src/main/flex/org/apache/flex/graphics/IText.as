/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.graphics
{
	public interface IText extends IGraphicShape
	{
		/**
         *  The text to draw.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.8
		 */
		function get text():String;
		function set text(value:String):void;

		/**
         *  Draw the text. (The same behavior as the default draw() method, but requires specifying the text, x and y explicitly.)
         *  @param xp The x position of the top-left corner of the bounding box of the ellipse.
         *  @param yp The y position of the top-left corner of the bounding box of the ellipse.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.8
		 */
		function drawText(value:String, xt:Number, yt:Number):void
	}
}