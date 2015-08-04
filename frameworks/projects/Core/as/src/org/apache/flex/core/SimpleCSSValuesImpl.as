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
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.ValueChangeEvent;
    import org.apache.flex.events.ValueEvent;
    import org.apache.flex.utils.CSSUtils;
    
    /**
     *  The SimpleCSSValuesImpl class implements a minimal set of
     *  CSS lookup rules that is sufficient for most applications.
     *  It does not support attribute selectors or descendant selectors
     *  or id selectors.  It will filter on a custom -flex-flash
     *  media query but not other media queries.  It can be
     *  replaced with other implementations that handle more complex
     *  selector lookups.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SimpleCSSValuesImpl extends EventDispatcher implements IValuesImpl
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SimpleCSSValuesImpl()
		{
			super();
		}
		
        private var mainClass:Object;
        
		private var conditionCombiners:Object;

        /**
         *  @copy org.apache.flex.core.IValuesImpl#init()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function init(mainClass:Object):void
        {
			var styleClassName:String;
			var c:Class;
			if (!values)
			{
				values = {};
	            this.mainClass = mainClass;
	            var mainClassName:String = getQualifiedClassName(mainClass);
				styleClassName = "_" + mainClassName + "_Styles";
				c = ApplicationDomain.currentDomain.getDefinition(styleClassName) as Class;
                generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
			}
			c = mainClass.constructor as Class;
            generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
            if (hasEventListener("init"))
                dispatchEvent(new ValueEvent("init", false, false, c["fontFaces"]));
            
            var i:int = 1;
            while (true)
            {
                var ffName:String = "factoryFunctions" + i.toString();
                var ff:Object = c[ffName];
                if (ff == null)
                    break;
                generateCSSStyleDeclarations(c[ffName], c["data" + i.toString()]);
                if (hasEventListener("init"))
                    dispatchEvent(new ValueEvent("init", false, false, c["fontFaces" + i.toString()]));
                i++;
            }
        }
        
        /**
         *  Process the encoded CSS data into data structures.  Usually not called
         *  directly by application developers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function generateCSSStyleDeclarations(factoryFunctions:Object, arr:Array):void
        {
			if (factoryFunctions == null)
				return;
			if (arr == null)
				return;
			
            var declarationName:String = "";
            var segmentName:String = "";
            var n:int = arr.length;
            for (var i:int = 0; i < n; i++)
            {
                var className:int = arr[i];
                if (className == CSSClass.CSSSelector)
                {
                    var selectorName:String = arr[++i];
                    segmentName = selectorName + segmentName;
                    if (declarationName != "")
                        declarationName += " ";
                    declarationName += segmentName;
                    segmentName = "";
                }
                else if (className == CSSClass.CSSCondition)
                {
					if (!conditionCombiners)
					{
						conditionCombiners = {};
						conditionCombiners["class"] = ".";
						conditionCombiners["id"] = "#";
						conditionCombiners["pseudo"] = ':';    
					}
					var conditionType:String = arr[++i];
					var conditionName:String = arr[++i];
					segmentName = segmentName + conditionCombiners[conditionType] + conditionName;
                }
                else if (className == CSSClass.CSSStyleDeclaration)
                {
                    var factoryName:int = arr[++i]; // defaultFactory or factory
                    var defaultFactory:Boolean = factoryName == CSSFactory.DefaultFactory;
                    /*
                    if (defaultFactory)
                    {
                        mergedStyle = styleManager.getMergedStyleDeclaration(declarationName);
                        style = new CSSStyleDeclaration(selector, styleManager, mergedStyle == null);
                    }
                    else
                    {
                        style = styleManager.getStyleDeclaration(declarationName);
                        if (!style)
                        {
                            style = new CSSStyleDeclaration(selector, styleManager, mergedStyle == null);
                            if (factoryName == CSSFactory.Override)
                                newSelectors.push(style);
                        }
                    }
                    */
                    var mq:String = null;
                    var o:Object;
                    if (i < n - 2)
                    {
                        // peek ahead to see if there is a media query
                        if (arr[i + 1] == CSSClass.CSSMediaQuery)
                        {
                            mq = arr[i + 2];
                            i += 2;
                            declarationName = mq + "_" + declarationName;
                        }
                    }
                    var finalName:String;
                    var valuesFunction:Function;
                    var valuesObject:Object;
                    if (defaultFactory)
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                    }
                    else
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                    }
                    if (isValidStaticMediaQuery(mq))
                    {
                        finalName = fixNames(declarationName, mq);
                        o = values[finalName];
                        if (o == null)
                            values[finalName] = valuesObject;
                        else
                        {
                            valuesFunction.prototype = o;
                            values[finalName] = new valuesFunction();
                        }
                    }
                    declarationName = "";
                }
            }
            
        }

        private function isValidStaticMediaQuery(mq:String):Boolean
        {
            if (mq == null)
                return true;
            
            if (mq == "-flex-flash")
                return true;
            
            // TODO: (aharui) other media query
            
            return false;
        }
        
        private function fixNames(s:String, mq:String):String
        {
            if (mq != null)
                s = s.substr(mq.length + 1); // 1 more for the hyphen
            
			if (s == "")
				return "*";
			
            var arr:Array = s.split(" ");
            var n:int = arr.length;
            for (var i:int = 0; i < n; i++)
            {
                var segmentName:String = arr[i];
				if (segmentName.charAt(0) == "#" || segmentName.charAt(0) == ".")
					continue;
				
                var c:int = segmentName.lastIndexOf(".");
                if (c > -1)	// it is 0 for class selectors
                {
                    segmentName = segmentName.substr(0, c) + "::" + segmentName.substr(c + 1);
                    arr[i] = segmentName;
                }
            }
            return arr.join(" ");
        }

        /**
         *  The map of values.  The format is not documented and it is not recommended
         *  to manipulate this structure directly.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var values:Object;
		
        /**
         *  @copy org.apache.flex.core.IValuesImpl#getValue()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
            var c:int = valueName.indexOf("-");
            while (c != -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName.substr(c + 2);
                c = valueName.indexOf("-");
            }

            var value:*;
			var o:Object;
			var className:String;
			var selectorName:String;
			
			if (thisObject is IStyleableObject)
			{
                var styleable:IStyleableObject = IStyleableObject(thisObject);
                if (styleable.style != null)
                {
                    try {
                        value = styleable.style[valueName];
                    }
                    catch (e:Error) {
                        value = undefined;
                    }
                    if (value == "inherit")
                        return getInheritingValue(thisObject, valueName, state, attrs);
                    if (value !== undefined)
                        return value;
                }
                if (styleable.id != null)
                {
                    o = values["#" + styleable.id];
                    if (o)
                    {
                        value = o[valueName];
                        if (value == "inherit")
                            return getInheritingValue(thisObject, valueName, state, attrs);
                        if (value !== undefined)
                            return value;
                    }                    
                }
				var classNames:String = styleable.className;
                if (classNames)
                {
                    var classNameList:Array = classNames.split(" ");
                    for each (className in classNameList)
                    {
                        if (state)
                        {
                            selectorName = className + ":" + state;
                            o = values["." + selectorName];
                            if (o)
                            {
                                value = o[valueName];
                                if (value == "inherit")
                                    return getInheritingValue(thisObject, valueName, state, attrs);
                                if (value !== undefined)
                                    return value;
                            }
                        }
                        
                        o = values["." + className];
                        if (o)
                        {
                            value = o[valueName];
                            if (value == "inherit")
                                return getInheritingValue(thisObject, valueName, state, attrs);
                            if (value !== undefined)
                                return value;
                        }                        
                    }
                }
			}
			
			className = getQualifiedClassName(thisObject);
            var thisInstance:Object = thisObject;
			while (className != "Object")
			{
				if (state)
				{
					selectorName = className + ":" + state;
					o = values[selectorName];
					if (o)
					{
						value = o[valueName];
                        if (value == "inherit")
                            return getInheritingValue(thisObject, valueName, state, attrs);
						if (value !== undefined)
							return value;
					}
				}
				
	            o = values[className];
	            if (o)
	            {
	                value = o[valueName];
                    if (value == "inherit")
                        return getInheritingValue(thisObject, valueName, state, attrs);
	                if (value !== undefined)
	                    return value;
	            }
				className = getQualifiedSuperclassName(thisInstance);
				thisInstance = getDefinitionByName(className);
			}
            
            if (inheritingStyles[valueName] != null && 
                thisObject is IChild)
            {
                var parentObject:Object = IChild(thisObject).parent;
                if (parentObject)
                    return getValue(parentObject, valueName, state, attrs);
            }
            
            o = values["global"];
            if (o)
            {
    			value = o[valueName];
    			if (value !== undefined)
    				return value;
            }
			o = values["*"];			
			if(o)
			{
				return o[valueName];
			}
			return undefined;
		}
		
        private function getInheritingValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
        {
            var value:*;
            if (thisObject is IChild)
            {
                var parentObject:Object = IChild(thisObject).parent;
                if (parentObject)
                {
                    value = getValue(parentObject, valueName, state, attrs);
                    if (value == "inherit" || value === undefined)
                        return getInheritingValue(parentObject, valueName, state, attrs);
                    if (value !== undefined)
                        return value;
                }
                return undefined;
            }
            return "inherit";
        }
        
        /**
         *  A method that stores a value to be shared with other objects.
         *  It is global, not per instance.  Fancier implementations
         *  may store shared values per-instance.
         * 
         *  @param thisObject An object associated with this value.  Thiis
         *                parameter is ignored.
         *  @param valueName The name or key of the value being stored.
         *  @param The value to be stored.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function setValue(thisObject:Object, valueName:String, value:*):void
		{
            var c:int = valueName.indexOf("-");
            while (c != -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName..substr(c + 2);
                c = valueName.indexOf("-");
            }
			var oldValue:Object = values[valueName];
			if (oldValue != value)
			{
				values[valueName] = value;
				dispatchEvent(new ValueChangeEvent(ValueChangeEvent.VALUE_CHANGE, false, false, oldValue, value));
			}
		}
        
		/**
		 *  @copy org.apache.flex.core.IValuesImpl#newInstance()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function newInstance(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
			var c:Class = getValue(thisObject, valueName, state, attrs);
			if (c)
				return new c();
			return null;
		}
		
        /**
         *  @copy org.apache.flex.core.IValuesImpl#getInstance()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getInstance(valueName:String):Object
        {
            var o:Object = values["global"];
            if (o is Class)
            {
                o[valueName] = new o[valueName]();
                if (o[valueName] is IDocument)
                    o[valueName].setDocument(mainClass);
            }
            return o[valueName];
        }
        
        /**
         *  @copy org.apache.flex.core.IValuesImpl#convertColor()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function convertColor(value:Object):uint
        {
            return CSSUtils.toColor(value);
        }
        
        /**
         *  @copy org.apache.flex.core.IValuesImpl#parseStyles()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function parseStyles(styles:String):Object
        {
            var obj:Object = {};
            var parts:Array = styles.split(";");
            for each (var part:String in parts)
            {
                var pieces:Array = part.split(":");
                var value:String = pieces[1];
                if (value == "null")
                    obj[pieces[0]] = null;
                else if (value == "true")
                    obj[pieces[0]] = true;
                else if (value == "false")
                    obj[pieces[0]] = false;
                else
                {
                    var n:Number = Number(value);
                    if (isNaN(n))
                    {
                        if (value.charAt(0) == "#")
                        {                            
                            obj[pieces[0]] = CSSUtils.toColor(value);
                        }
                        else
                        {
                            if (value.charAt(0) == "'")
                                value = value.substr(1, value.length - 2);
                            else if (value.charAt(0) == '"')
                                value = value.substr(1, value.length - 2);
                            obj[pieces[0]] = value;
                        }
                    }
                    else
                        obj[pieces[0]] = n;
                }
            }
            return obj;
        }
        
        /**
         *  A map of inheriting styles 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var inheritingStyles:Object = { 
            "color" : 1,
            "fontFamily" : 1,
            "fontSize" : 1,
            "fontStyle" : 1,
            "textAlign" : 1
        }
                                                        
	}
}

class CSSClass
{
    public static const CSSSelector:int = 0;
    public static const CSSCondition:int = 1;
    public static const CSSStyleDeclaration:int = 2;
    public static const CSSMediaQuery:int = 3;
}

class CSSFactory
{
    public static const DefaultFactory:int = 0;
    public static const Factory:int = 1;
    public static const Override:int = 2;
}

class CSSDataType
{
    public static const Native:int = 0;
    public static const Definition:int = 1;
}