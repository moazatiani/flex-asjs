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
package org.apache.flex.mdl
{
	import org.apache.flex.html.Group;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	/**
	 *  The TableCell class is a Cell for MDL Table used normaly in a TableRowItemRenderer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class TableCell extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function TableCell()
		{
			super();
		}

		private var _text:String = "";

        /**
         *  The text of the td
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get text():String
		{
            return _text;
		}
		public function set text(value:String):void
		{
            _text = value;

			COMPILE::JS
			{
                if(textNode == null)
                {
                    textNode = document.createTextNode('') as Text;
                    element.appendChild(textNode);
                }

                textNode.nodeValue = value;
			}
		}

		COMPILE::JS
        protected var textNode:Text;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			element = document.createElement('td') as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		private var _nonNumeric:Boolean;
        /**
         *  Activate "mdl-data-table__cell--non-numeric" class selector, for use in table td item.
         *  Applies text formatting to data cell. Numeric is the default
		 *  Optional; goes on both table header and table data cells
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get nonNumeric():Boolean
        {
            return _nonNumeric;
        }
        public function set nonNumeric(value:Boolean):void
        {
            _nonNumeric = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-data-table__cell--non-numeric", _nonNumeric);
				typeNames = element.className;
            }
        }
	}
}
