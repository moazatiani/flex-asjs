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
package org.apache.flex.core
{
    COMPILE::SWF {
		import flash.display.StageAlign;
		import flash.display.StageQuality;
		import flash.display.StageScaleMode;
		import flash.events.Event;
		import flash.utils.getDefinitionByName;
    }
        
    /**
     *  This is a platform-dependent base class
     *  for Application
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class ApplicationFactory extends WrappedMovieClip
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ApplicationFactory()
		{
			super();
			
			if (stage)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				// should be opt-in
				//stage.quality = StageQuality.HIGH_16X16_LINEAR;
			}
			
			loaderInfo.addEventListener(flash.events.Event.INIT, initHandler);
		}

		private function initHandler(event:flash.events.Event):void
		{
			nextFrame();
			addEventListener(flash.events.Event.ENTER_FRAME, deferredFrameHandler);
		}
		
		private function deferredFrameHandler(e:flash.events.Event):void
		{			
			var mainClassName:String = info()["mainClassName"];
			
			var app:ISWFApplication =  create() as ISWFApplication;
			if (app)
			{
				removeEventListener(flash.events.Event.ENTER_FRAME, deferredFrameHandler);
				app.setRoot(this);		
			}
			else if (currentFrame == 1)
			    nextFrame();
		}
		
		private var _info:Object = {};
		/**
		 *  @private
		 */
		public function info():Object
		{
			return _info;
		}
		
		/**
		 *  A factory method that requests an instance of a
		 *  definition known to the module.
		 * 
		 *  You can provide an optional set of parameters to let building
		 *  factories change what they create based on the
		 *  input. Passing null indicates that the default definition
		 *  is created, if possible. 
		 *
		 *  This method is overridden in the autogenerated subclass.
		 *
		 *  @param params An optional list of arguments. You can pass
		 *  any number of arguments, which are then stored in an Array
		 *  called <code>parameters</code>. 
		 *
		 *  @return An instance of the module, or <code>null</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function create(... params):Object
		{
			var mainClassName:String = info()["mainClassName"];
			
			COMPILE::SWF
			{
				if (mainClassName == null)
				{
					var url:String = loaderInfo.loaderURL;
					var dot:int = url.lastIndexOf(".");
					var slash:int = url.lastIndexOf("/");
					mainClassName = url.substring(slash + 1, dot);
				}				
			}
			
			var mainClass:Class = Class(getDefinitionByName(mainClassName));
			
			return mainClass ? new mainClass() : null;
		}

    }
}
