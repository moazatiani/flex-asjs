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
package org.apache.flex.effects.beads
{
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.effects.Effect;
	import org.apache.flex.effects.ICompoundEffect;
	import org.apache.flex.effects.IEffect;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class ParallelPlayBead implements IBead
	{
		private var host:ICompoundEffect;
		
		public function ParallelPlayBead()
		{
			super();
		}
		
		public function set strand(value:IStrand):void
		{
			host = value as ICompoundEffect;
			host.addEventListener('play', playHandler);
		}
		
		private function playHandler(e:Event):void
		{
			host.dispatchEvent(new Event(Effect.EFFECT_START));
			current = 0;
			var n:int = host.numChildren;
			for (var i:int = 0; i < n; i++)          
				playChildEffect(i);
		}
		
		
		private var current:int;
		
		private function playChildEffect(index:int):void
		{
			var child:IEffect = host.getChildAt(index);
			child.addEventListener(Effect.EFFECT_END, effectEndHandler);
			child.play();   
		}
		
		private function effectEndHandler(event:Event):void
		{
			(event.target as IEventDispatcher).removeEventListener(Effect.EFFECT_END, effectEndHandler);
			current++;
			if (current >= host.numChildren)
				host.dispatchEvent(new Event(Effect.EFFECT_END));
		}
		
	}
}