
/*
 FormValidator…

 Copyright (c) 2012, Andreas Lappe <nd@off-pist.de>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 - Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 - Neither the name of the kuehlhaus AG nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

(function() {
  var FormValidator;

  window.FormValidator = FormValidator = (function() {

    FormValidator.prototype.invalidClass = 'invalid';

    FormValidator.prototype.errorClass = 'form-error';

    FormValidator.prototype.regExEMail = /^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    FormValidator.prototype.regExNumber = /^\d+$/;

    FormValidator.prototype.form = false;

    FormValidator.prototype.event = void 0;

    FormValidator.prototype.message = '';

    FormValidator.prototype.messages = {
      email: 'Email-Adresse muss korrekt eingegeben werden!',
      minLength: 'Mindestlänge von | Zeichen!',
      maxLength: 'Maximale Länge von | Zeichen!',
      notEmpty: 'Feld muss ausgefüllt werden!',
      number: 'Wert muss ganzzahlig sein…',
      noLabel: 'Bitte treffen Sie eine Auswahl…',
      noSelectedOption: 'Bitte wählen Sie mindestens eine Kategorie aus…',
      dateFormat: 'Bitte im Format tt.mm.jjjj eingeben…',
      dateInvalid: 'Ungültiges Datum…',
      timeFormat: 'Bitte im Format ss:mm eingeben…',
      timeInvalid: 'Ungültige Uhrzeit…',
      minNumber: 'Zahl muss größer als | sein…',
      maxNumber: 'Zahl muss kleiner als | sein…',
      checkbox: 'Checkbox muss ausgewählt sein…'
    };

    FormValidator.prototype.selectorEngine = void 0;

    function FormValidator() {
      if (typeof jQuery !== "undefined" && jQuery !== null) {
        if (jQuery.fn.jquery.match(/^1\.7.*$/)) this.selectorEngine = 'jQuery';
      } else if (typeof Ext !== "undefined" && Ext !== null) {
        if (Ext.versions.core.version.match(/^4\..*$/)) {
          this.selectorEngine = 'Ext';
        }
      }
      if (this.selectorEngine == null) {
        throw new Error('Neither jQuery nor Ext found… but I need a selector-engine to work!');
      }
    }

    FormValidator.prototype._hasCls = function(field, cls) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).hasClass(cls);
        case 'Ext':
          return (Ext.fly(field)).hasCls(cls);
      }
    };

    FormValidator.prototype._addCls = function(field, cls) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).addClass(cls);
        case 'Ext':
          return (Ext.fly(field)).addCls(cls);
      }
    };

    FormValidator.prototype._removeCls = function(field, cls) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).removeClass(cls);
        case 'Ext':
          return (Ext.fly(field)).removeCls(cls);
      }
    };

    FormValidator.prototype._parent = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).parent();
        case 'Ext':
          return (Ext.fly(field)).parent();
      }
    };

    FormValidator.prototype._createChild = function(parent, child) {
      var string;
      switch (this.selectorEngine) {
        case 'jQuery':
          string = '<' + child.tag + ' class="' + child.cls + '"><div class="message">' + child.html + '</div></' + child.tag + '>';
          return (jQuery(parent)).append(string);
        case 'Ext':
          return (Ext.fly(parent)).createChild(child);
      }
    };

    FormValidator.prototype._stopEvent = function(ev) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return ev.preventDefault();
        case 'Ext':
          return ev.stopEvent();
      }
    };

    FormValidator.prototype._remove = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).remove();
        case 'Ext':
          return (Ext.fly(field)).remove();
      }
    };

    FormValidator.prototype._select = function(root, selectors) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(root)).find(selectors);
        case 'Ext':
          return ((Ext.fly(root)).select(selectors)).elements;
      }
    };

    FormValidator.prototype._getValue = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).val();
        case 'Ext':
          return (Ext.fly(field)).getValue();
      }
    };

    FormValidator.prototype._isIE = function() {
      switch (this.selectorEngine) {
        case 'jQuery':
          return jQuery.browser.msie;
        case 'Ext':
          return Ext.isIE;
      }
    };

    FormValidator.prototype._getClasses = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          if (this._isIE()) {
            return (jQuery(field)).attr('className');
          } else {
            return (jQuery(field)).attr('class');
          }
          break;
        case 'Ext':
          if (this._isIE()) {
            return (Ext.fly(field)).getAttribute('className');
          } else {
            return (Ext.fly(field)).getAttribute('class');
          }
      }
    };

    FormValidator.prototype._getSelectedIndex = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).prop('selectedIndex');
        case 'Ext':
          return (Ext.fly(field)).dom.selectedIndex;
      }
    };

    FormValidator.prototype._isChecked = function(field) {
      switch (this.selectorEngine) {
        case 'jQuery':
          return (jQuery(field)).is(':checked');
        case 'Ext':
          return this._getValue(field);
      }
    };

    FormValidator.prototype._parseDate = function(date, format) {
      var day, month, regex, year;
      switch (this.selectorEngine) {
        case 'jQuery':
          switch (format) {
            case 'd.m.Y':
              if ((date.match(/^(\d+)\.(\d+)\.(\d+)$/)) == null) return null;
              regex = /^(\d+)\.(\d+)\.(\d+)$/;
              day = (parseInt(date.replace(regex, '$1'), 10)) - 1;
              month = (parseInt(date.replace(regex, '$2'), 10)) - 1;
              year = (parseInt(date.replace(regex, '$3'), 10)) - 1;
              if (day > 30 || month > 11 || year < 1970 || year > 2060) {
                return null;
              }
              return new Date(year, month, day);
            case 'm/d/Y' && date.match(/^(\d+)\/(\d+)\/(\d+)$/):
              regex = /^(\d+)\/(\d+)\/(\d+)$/;
              day = date.replace(regex, '$1');
              month = date.replace(regex, '$2');
              year = date.replace(regex, '$3');
              return new Date(year, month, day);
            default:
              return null;
          }
          break;
        case 'Ext':
          return Ext.Date.parse(date, format, true);
      }
    };

    FormValidator.prototype.markFieldInvalid = function(field) {
      var box, relatedErrors;
      box = field.parent();
      if (!(this._hasCls(field, this.invalidClass))) {
        this._addCls(field, this.invalidClass);
      }
      this.removeErrors(field);
      if (this.selectorEngine === 'jQuery') {
        relatedErrors = (jQuery(field)).parents('fieldset').find('.' + this.errorClass);
        if (relatedErrors.length === 0) {
          this._createChild(box, {
            tag: 'div',
            cls: this.errorClass,
            html: this.message
          });
        }
      } else {
        this._createChild(box, {
          tag: 'div',
          cls: this.errorClass,
          html: this.message
        });
      }
      if (this.form) this._stopEvent(this.event);
      return this;
    };

    FormValidator.prototype.markFieldValid = function(field) {
      if (this._hasCls(field, this.invalidClass)) {
        this._removeCls(field, this.invalidClass);
      }
      this.removeErrors(field);
      return this;
    };

    FormValidator.prototype.removeErrors = function(field) {
      var el, _i, _len, _ref;
      _ref = this._select(this._parent(field), '.' + this.errorClass);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        this._remove(el);
      }
      return this;
    };

    FormValidator.prototype.validate = function(field) {
      var allowEmpty, classes, date, dt, fields, hours, max, maxLength, min, minLength, minutes, option, selectedIndex, status, time, value;
      status = true;
      if ((this._hasCls(field, 'validate-notEmpty')) && status) {
        if ((this._getValue(field)).length < 1) {
          this.message = this.messages.notEmpty;
          status = false;
        }
      }
      if ((this._hasCls(field, 'validate-email')) && status) {
        if (!this.regExEMail.test(this._getValue(field))) {
          this.message = this.messages.email;
          status = false;
        }
      }
      if ((this._hasCls(field, 'validate-length')) && status) {
        value = this._getValue(field);
        classes = this._getClasses(field);
        allowEmpty = this._hasCls(field, 'validate-length-allowEmpty') ? true : false;
        minLength = (classes.match(/validate-length-min/)) != null ? parseInt(classes.replace(/.*validate-length-min(\d*).*/, '$1'), 10) : null;
        maxLength = (classes.match(/validate-length-max/)) != null ? parseInt(classes.replace(/.*validate-length-max(\d*).*/, '$1'), 10) : null;
        if (allowEmpty) {
          if (value.length > 0 && length.length < minLength) {
            this.message = this.messages.length.replace(/\|/, length);
            status = false;
          }
        } else {
          if ((minLength != null) && value.length < minLength) {
            this.message = this.messages.minLength.replace(/\|/, minLength);
            status = false;
          }
          if ((maxLength != null) && value.length > maxLength) {
            this.message = this.messages.maxLength.replace(/\|/, maxLength);
            status = false;
          }
        }
      }
      if ((this._hasCls(field, 'validate-number')) && status) {
        if (!this.regExNumber.test(this._getValue(field))) {
          this.message = this.messages.number;
          status = false;
        }
        if ((this._hasCls(field, 'validate-number-range')) && status) {
          classes = this._getClasses(field);
          min = (classes.match(/validate-number-range-min/)) != null ? parseInt(classes.replace(/.*validate-number-range-min(\d*).*/, '$1'), 10) : null;
          max = (classes.match(/validate-number-range-max/)) != null ? parseInt(classes.replace(/.*validate-number-range-max(\d*).*/, '$1'), 10) : null;
          if (!((min != null) && (max != null))) {
            if ((classes.match(/validate-number-range-\d-\d/)) != null) {
              min = parseInt(classes.replace(/.*validate-number-range-(\d+).*/, '$1'), 10);
              max = parseInt(classes.replace(/.*validate-number-range-(\d+)-(\d+).*/, '$2'), 10);
            }
          }
          value = parseInt(this._getValue(field), 10);
          if ((min != null) && value < min) {
            this.message = this.messages.minNumber.replace(/\|/, min - 1);
            status = false;
          }
          if ((max != null) && value > max) {
            this.message = this.messages.maxNumber.replace(/\|/, max + 1);
            status = false;
          }
        }
      }
      if ((this._hasCls(field, 'validate-select')) && status) {
        if (this._hasCls(field, 'validate-select-noLabel')) {
          fields = (function() {
            var _i, _len, _ref, _results;
            _ref = this._select(field, 'option');
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              option = _ref[_i];
              if (option.selected && option.value.match(/^-+$/)) {
                this.message = this.messages.noLabel;
                _results.push(status = false);
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          }).call(this);
        }
        if (this._hasCls(field, 'validate-select-notEmpty')) {
          selectedIndex = this._getSelectedIndex(field);
          if (selectedIndex === -1) {
            this.message = this.messages.noSelectedOption;
            status = false;
          }
        }
      }
      if ((this._hasCls(field, 'validate-date')) && status) {
        date = this._getValue(field);
        if (!date.match(/\d{2}\.\d{2}\.\d{4}/)) {
          this.message = this.messages.dateFormat;
          status = false;
        }
        dt = this._parseDate(date, 'd.m.Y');
        if (dt == null) {
          this.message = this.messages.dateInvalid;
          status = false;
        }
      }
      if ((this._hasCls(field, 'validate-time')) && status) {
        time = this._getValue(field);
        if (!time.match(/\d{2}:\d{2}/)) {
          if (this._hasCls(field, 'validate-allowEmpty')) {
            if (time.length !== 0) {
              this.message = this.messages.timeFormat;
              status = false;
            }
          } else {
            this.message = this.messages.timeFormat;
            status = false;
          }
        } else {
          hours = parseInt(time.replace(/^(\d{2}):.*/, '$1'), 10);
          minutes = parseInt(time.replace(/^.*:(\d{2})$/, '$1'), 10);
          if (!((hours >= 0 && hours <= 23) && (minutes >= 0 && minutes <= 59))) {
            this.message = this.messages.timeInvalid;
            status = false;
          }
        }
      }
      if ((this._hasCls(field, 'validate-checkbox')) && status) {
        if (!this._isChecked(field)) {
          this.message = this.messages.checkbox;
          status = false;
        }
      }
      if (!status) {
        this.markFieldInvalid(field);
      } else {
        this.markFieldValid(field);
      }
      return status;
    };

    return FormValidator;

  })();

}).call(this);
