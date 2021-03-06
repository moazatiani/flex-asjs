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

package org.apache.flex.svg
{
	COMPILE::SWF
    {
		import flash.display.Graphics;
		import flash.display.Sprite;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import org.apache.flex.core.WrappedSprite;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

    import org.apache.flex.core.IFlexJSElement;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.graphics.IFill;
	import org.apache.flex.graphics.IStroke;
	import org.apache.flex.graphics.IGraphicShape;

	public class GraphicShape extends UIBase implements IGraphicShape
	{

		private var _fill:IFill;
		private var _stroke:IStroke;

		public function get stroke():IStroke
		{
			return _stroke;
		}

		/**
		 *  A solid color fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}

		public function get fill():IFill
		{
			return _fill;
		}
		/**
		 *  A solid color fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set fill(value:IFill):void
		{
			_fill = value;
		}

		/**
		 * Constructor
		 *
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
        public function GraphicShape()
        {
			super();
        }

		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			//element.offsetParent = null;
			positioner = element;
			//positioner.style.position = 'relative';

			return element;
		}
		
		/**
		 * @private
		 * @flexjsignorecoercion SVGRect
		 */
		COMPILE::JS
		protected function getBBox(svgElement:WrappedHTMLElement):Object
		{
			try {
				return svgElement['getBBox']();
			} catch (err) {
				return {x: 0, y:0, width:this.width, height:this.height};
			}
		}


        COMPILE::SWF
		protected function applyStroke():void
		{
			if(stroke)
			{
				stroke.apply(graphics);
			}
		}

        COMPILE::SWF
		protected function beginFill(targetBounds:Rectangle,targetOrigin:Point):void
		{
			if(fill)
			{
				fill.begin(graphics, targetBounds,targetOrigin);
			}
		}

        COMPILE::SWF
		protected function endFill():void
		{
			if(fill)
			{
				fill.end(graphics);
			}
		}

		/**
		 * This is where the drawing methods get called from
		 */
		protected function drawImpl():void
		{
			//Overwrite in subclass
		}

		override public function addedToParent():void
		{
            super.addedToParent();
			drawImpl();
            COMPILE::JS
            {
                element.style.overflow = 'visible';
            }
		}

        /**
         * @return {string} The style attribute.
         */
        COMPILE::JS
        public function getStyleStr():String
        {
            var fillStr:String;
            if (fill)
            {
                fillStr = fill.addFillAttrib(this);
            }
            else
            {
                fillStr = 'fill:none';
            }

            var strokeStr:String;
            if (stroke)
            {
                strokeStr = stroke.addStrokeAttrib(this);
            }
            else
            {
                strokeStr = 'stroke:none';
            }


            return fillStr + ';' + strokeStr;
        }

		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			element.setAttribute('class', value);
		}


        /**
         * @param x X position.
         * @param y Y position.
         * @param bbox The bounding box of the svg element.
         */
        COMPILE::JS
        public function resize(x:Number, y:Number, bbox:Object):void
        {
            var useWidth:Number = Math.max(this.width, bbox.width);
            var useHeight:Number = Math.max(this.height, bbox.height);

            element.style.position = 'absolute';
            if (!isNaN(x)) element.style.top = x + "px";
            if (!isNaN(y)) element.style.left = y + "px";
			// element.setAttribute("width", useWidth);
			// element.setAttribute("height", useHeight);
            element.style.width = useWidth;
            element.style.height = useHeight;
			// Needed for SVG inside SVG
			element.setAttribute("x", x);
			element.setAttribute("y", y);
			//Needed for SVG inside DOM elements
            element.style.left = x + "px";
            element.style.top = y + "px";
        }

        COMPILE::JS
        private var _x:Number;
        COMPILE::JS
        private var _y:Number;
        COMPILE::JS
        private var _xOffset:Number;
        COMPILE::JS
        private var _yOffset:Number;

        /**
         * @param x X position.
         * @param y Y position.
         * @param xOffset offset from x position.
         * @param yOffset offset from y position.
         */
        COMPILE::JS
        public function setPosition(x:Number, y:Number, xOffset:Number, yOffset:Number):void
        {
            _x = x;
            _y = y;
            _xOffset = xOffset;
            _yOffset = yOffset;
			// Needed for SVG inside SVG
			element.setAttribute("x", xOffset);
			element.setAttribute("y", yOffset);
			//Needed for SVG inside DOM elements
            element.style.left = xOffset + "px";
            element.style.top = yOffset + "px";
        }
	}
}
