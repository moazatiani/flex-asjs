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
package org.apache.flex.charts.beads.controllers
{
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ItemAddedEvent;
	import org.apache.flex.events.ItemRemovedEvent;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.beads.IListView;

	import org.apache.flex.events.ItemClickedEvent;

	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartDataModel;

	public class ChartSeriesMouseController implements IBeadController
	{
		public function ChartSeriesMouseController()
		{

		}

		/**
		 *  The model.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected var listModel:IChartDataModel;

		/**
		 *  The view.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected var listView:IListView;

		/**
		 *  The parent of the item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected var dataGroup:IItemRendererParent;

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			listModel = value.getBeadByType(IChartDataModel) as IChartDataModel;
			listView = value.getBeadByType(IListView) as IListView;
			IEventDispatcher(_strand).addEventListener("itemAdded", handleItemAdded);
			IEventDispatcher(_strand).addEventListener("itemRemoved", handleItemRemoved);
		}

		protected function handleItemAdded(event:ItemAddedEvent):void
		{
			IEventDispatcher(event.item).addEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOut", rolloutHandler);
		}

		protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			IEventDispatcher(event.item).removeEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOut", rolloutHandler);
		}

		protected function selectedHandler(event:ItemClickedEvent):void
		{
			var renderer:IChartItemRenderer = event.currentTarget as IChartItemRenderer;
			if (renderer) {
				listModel.selectedSeries = renderer.series;
				listModel.selectedIndex = event.index;
				listView.host.dispatchEvent(new Event("change"));
			}
		}

		protected function rolloverHandler(event:Event):void
		{
			var renderer:IChartItemRenderer = event.currentTarget as IChartItemRenderer;
			if (renderer) {
				//renderer.hovered = true;
				listModel.rollOverSeries = renderer.series;
				listModel.rollOverIndex = renderer.index;
			}
		}

		protected function rolloutHandler(event:Event):void
		{
			var renderer:ISelectableItemRenderer = event.currentTarget as ISelectableItemRenderer;
			if (renderer) {
				renderer.hovered = false;
				renderer.down = false;
				listModel.rollOverSeries = null;
				listModel.rollOverIndex = -1;
			}
		}
	}
}
