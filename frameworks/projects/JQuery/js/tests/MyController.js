/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('MyController');

goog.require('flash.events.EventDispatcher');

goog.require('org.apache.flex.FlexGlobal');

/**
 * @constructor
 * @param {org.apache.flex.core.Application} app The main application.
 */
MyController = function(app) {
    /**
     * @type {org.apache.flex.core.Application}
     */
    this.app = app || null;

    this.app.addEventListener(
        'viewChanged', org.apache.flex.FlexGlobal.createProxy(
            this, this.viewChangeHandler
        )
    );
};

/**
 * @this {MyController}
 * @param {flash.events.Event} event The event.
 */
MyController.prototype.viewChangeHandler = function(event) {
    this.app.initialView.addEventListener(
        'buttonClicked', org.apache.flex.FlexGlobal.createProxy(
            this, this.buttonClickHandler
        )
    );
};

/**
 * @this {MyController}
 * @param {flash.events.Event} event The event.
 */
MyController.prototype.buttonClickHandler = function(event) {
    this.app.model.set_labelText('Hello Universe');
};
