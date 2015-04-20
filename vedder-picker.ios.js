/**
 * Copyright (c) 2015-present Dave Vedder
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. 
 *
 * @providesModule VPickerIOS
 *
 * This is a controlled component version of VDRPickerIOS
 *
 * WARNING: this is a proof of concept. Don't use it for reals yet. Also,
 * if your container has `flex` set on it, the picker moves around oddly.
 * I'm not sure if that's something I broke, or it happens in the default one 
 * as well. In addition, if you set a `width` on your picker, it seems to not 
 * behave properly. Set a background color on it when you set the width and
 * you will see what I mean.
 *
 */
'use strict';

var NativeMethodsMixin = require('NativeMethodsMixin');
var React = require('React');
var ReactChildren = require('ReactChildren');
var ReactIOSViewAttributes = require('ReactIOSViewAttributes');
var VDRPickerIOSConsts = require('NativeModules').UIManager.VDRPicker.Constants;
var StyleSheet = require('StyleSheet');
var View = require('View');

var createReactIOSNativeComponentClass =
  require('createReactIOSNativeComponentClass');
var merge = require('merge');

var PICKER = 'picker';

var VPickerIOS = React.createClass({

    mixins: [NativeMethodsMixin],

    _stateFromProps: function (props) {
        // You could just set the componentData and selectedIndexes directly,
        // as props on the top level Picker then you can skip all this,
        // but this assumes you did it with child components
        // like the existing one. 
        //
        // It might makes sense to check if these props exist and skip
        // iterating over the kids (or see if there are children and skip the
        // props maybe?) but perhaps always using child elements is the 
        // more "Reacty" way of doing things.
        var componentData = [];
        var selectedIndexes = [];

        ReactChildren.forEach(props.children, function (child, index) {

            // Again, you *could* just do this if you set the items prop directly:
            //          componentData.push(child.props.items);
            // but I'm copying the existing picker way of having it always be
            // done via child elements. (See above!)

            // from each PickerItem...
            var items = []
            var selectedIndex = 0; // sane default
            var checkVal = child.props.selectedValue;
            React.Children.forEach(child.props.children, function (child, idx) {
                if (checkVal === child.props.value) {
                    selectedIndex = idx;
                }
                items.push({label: child.props.label, value: child.props.value}); 
            });
            componentData.push(items);
            selectedIndexes.push(selectedIndex);
        });
        return { componentData, selectedIndexes };
    },

    getInitialState: function() {
        return this._stateFromProps(this.props);
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState(this._stateFromProps(nextProps));
    },

    _onChange: function (event) {
        if (this.props.onChange) {
            this.props.onChange(event);
        }
        if (this.props.valueChange) {
            this.props.valueChange(event);
        }
        this.refs[PICKER].setNativeProps({
            selectedIndexes: this.state.selectedIndexes,
            componentData: this.state.componentData,
        });
    },

    render: function() {
        return (
            <View style={this.props.style}>
                <VDRPickerIOS
                    ref={PICKER}
                    style={styles.rkPickerIOS}
                    selectedIndexes={this.state.selectedIndexes}
                    componentData={this.state.componentData}
                    onChange={this._onChange}
                />
            </View>
        );
    },

});

VPickerIOS.PickerComponent = React.createClass({
    propTypes: {
        items: React.PropTypes.array,
        selectedIndex: React.PropTypes.number,
    },
    render: function () {
        return null;
    },
});

// almost directly from FB codebase
VPickerIOS.Item = React.createClass({
  propTypes: {
    value: React.PropTypes.any, // string or integer basically
    label: React.PropTypes.string,
  },

  render: function() {
    // These items don't get rendered directly.
    return null;
  },
});

var styles = StyleSheet.create({
  rkPickerIOS: {
    height: VDRPickerIOSConsts.ComponentHeight,
  },
});

var exposedPickerAttributes = merge(ReactIOSViewAttributes.UIView, {
    componentData: true,
    selectedIndexes: true,
});

var VDRPickerIOS = createReactIOSNativeComponentClass({
  validAttributes: exposedPickerAttributes,
  uiViewClassName: 'VDRPicker',
});

module.exports = VPickerIOS;

