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
package org.apache.flex.html.beads
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	
    /**
     *  The HScrollBarTrackView class is the view for
     *  the track in a Horizontal ScrollBar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HScrollBarTrackView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HScrollBarTrackView()
		{
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();

		}
		
		private function drawView(g:Graphics, bgColor:uint, w:Number):void
		{
			g.clear();
			g.lineStyle(1);
			g.beginFill(bgColor);
			g.drawRect(0, 0, w, 16);
			g.endFill();
			g.lineStyle(0);
		}

		private function widthChangeHandler(event:Event):void
		{
			DisplayObject(_strand).scaleY = 1.0;
			DisplayObject(_strand).scaleX = 1.0;
			
			var w:Number = SimpleButton(_strand).width;
			
			drawView(upView.graphics, 0xCCCCCC, w);
			drawView(downView.graphics, 0x808080, w);
			drawView(overView.graphics, 0xEEEEEE, w);	
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 16, w);
			shape.graphics.endFill();
			
		}
		
		private var shape:Shape;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			SimpleButton(value).addEventListener("widthChanged", widthChangeHandler);
			shape = new Shape();
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = shape;
		}

		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
	}
}
