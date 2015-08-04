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

goog.provide('org.apache.flex.events.EventDispatcher');

goog.require('goog.events.EventTarget');
goog.require('org.apache.flex.events.ElementEvents');
goog.require('org.apache.flex.events.IEventDispatcher');



/**
 * @constructor
 * @extends {goog.events.EventTarget}
 * @implements {org.apache.flex.events.IEventDispatcher}
 */
org.apache.flex.events.EventDispatcher = function() {
  org.apache.flex.events.EventDispatcher.base(this, 'constructor');
};
goog.inherits(org.apache.flex.events.EventDispatcher,
    goog.events.EventTarget);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.EventDispatcher.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'EventDispatcher',
                qName: 'org.apache.flex.events.EventDispatcher'}],
      interfaces: [org.apache.flex.events.IEventDispatcher] };


/**
 * @override
 */
org.apache.flex.events.EventDispatcher.prototype.addEventListener =
    function(type, handler, opt_capture, opt_handlerScope) {
  var source;

  /**
   *  A bit of a hack, but for 'native' HTML element based controls, we
   *  want to listen to the 'native' events from the element; for other
   *  types of controls, we listen to 'custom' events.
   */
  source = this;
  if (this.element && this.element.nodeName &&
      this.element.nodeName.toLowerCase() !== 'div' &&
      this.element.nodeName.toLowerCase() !== 'body') {
    source = this.element;
  } else if (org.apache.flex.events.ElementEvents.elementEvents[type]) {
    // mouse and keyboard events also dispatch off the element.
    source = this.element;
  }

  goog.events.listen(source, type, handler);
};

