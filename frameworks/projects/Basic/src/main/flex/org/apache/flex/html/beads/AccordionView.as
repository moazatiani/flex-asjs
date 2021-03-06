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
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStyleableObject;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.layouts.IOneFlexibleChildLayout;
	import org.apache.flex.html.supportClasses.ICollapsible;
	import org.apache.flex.utils.StrandUtils;
	
	public class AccordionView extends ListView
	{
		private var _layout:IOneFlexibleChildLayout;
		public function AccordionView()
		{
			super();
		}
		
		override protected function selectionChangeHandler(event:Event):void
		{
			super.selectionChangeHandler(event);
			var renderer:IStyleableObject = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IStyleableObject;
			layout.flexibleChild = renderer.id;
		}
		
		public function get layout():IOneFlexibleChildLayout
		{
			if (!_layout)
			{
				_layout = _strand.getBeadByType(IOneFlexibleChildLayout) as IOneFlexibleChildLayout;
				if (!_layout) {
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
					if (c) {
						_layout = new c() as IOneFlexibleChildLayout;
					}
				}
				if (_layout)
				{
					_strand.addBead(_layout);
				}
			}
			return _layout;
		}
		
		override protected function performLayout(event:Event):void
		{
			if (layout)
			{
				if (!layout.flexibleChild)
				{
					var model:ISelectionModel = StrandUtils.loadBead(ISelectionModel, "iBeadModel", host) as ISelectionModel;
					if (model.selectedIndex > -1)
					{
						layout.flexibleChild = (dataGroup.getItemRendererForIndex(model.selectedIndex) as IStyleableObject).id;
					}
				}
				super.performLayout(event);
			}
		}
		
		COMPILE::SWF
		override protected function itemsCreatedHandler(event:Event):void
		{
			var n:int = dataGroup.numElements;
			for (var i:int = 0; i < n; i++)
			{
				var child:ICollapsible = dataGroup.getItemRendererForIndex(i) as ICollapsible;
				child.collapse();
			}
			super.itemsCreatedHandler(event);
		}
	}
}