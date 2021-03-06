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
package org.apache.flex.html
{
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.IAccordionCollapseBead;
	
	
	/**
	 *  The Accordion class used to display a list of collapsible components
	 *  All but the selected item are expected to be collapsed.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */    
	public class Accordion extends List
	{
		private var _collapseBead:IAccordionCollapseBead;
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Accordion()
		{
			super();
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
			accordionCollapseBead; // make sure it's initialized
			if (selectedIndex < 0)
			{
				selectedIndex = 0;
			} else
			{
				// TODO this should probably be done in List, but it's too hacky
				// This is my way of setting the proper item renderer state and layout 
				(model as IEventDispatcher).dispatchEvent(new Event("selectedIndexChanged"));
			}
		}
		
		public function get accordionCollapseBead():IAccordionCollapseBead
		{
			if (_collapseBead == null)
			{
				_collapseBead = getBeadByType(IAccordionCollapseBead) as IAccordionCollapseBead;
				if (_collapseBead == null)
				{
					var c:Class = ValuesManager.valuesImpl.getValue(this, "iAccordionCollapseBead") as Class;
					if (c)
					{
						if (c)
						{
							_collapseBead = (new c()) as IAccordionCollapseBead;
						}
					}
				}
				if (_collapseBead)
				{
					addBead(_collapseBead);
				}
			}
			return _collapseBead;
		}
		
		
	}
}
