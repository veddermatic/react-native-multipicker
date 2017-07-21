/**
 * Copyright (c) 2015-present Dave Vedder
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @providesModule MultiPickerIOS
 *
 */
'use strict';

import React from 'react';
import { StyleSheet, View, UIManager, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types';

const RNMultiPicker = requireNativeComponent('RNMultiPicker', MultiPickerIOS);
const RNMultiPickerConsts = UIManager.RNMultiPicker.Constants;
const PICKER_REF = 'picker';

const styles = StyleSheet.create({
  multipicker: {
    height: RNMultiPickerConsts.ComponentHeight,
  },
});

export class MultiPickerIOS extends React.Component {
  static propTypes = {
    componentData: PropTypes.any,
    selectedIndexes: PropTypes.array,
    onChange: PropTypes.func,
  };

  constructor(props) {
    super(props);

    const componentData = [];
    const selectedIndexes = [];

    React.Children.forEach(props.children, (child, index) => {
      const items = [];

      let selectedIndex;
      if (child.props.selectedIndex) {
        selectedIndex = child.props.selectedIndex;
      } else if (child.props.initialSelectedIndex && !this.state) {
        selectedIndex = child.props.initialSelectedIndex;
      } else {
        selectedIndex = 0;
      }

      React.Children.forEach(child.props.children, function (child, idx) {
        items.push({ label: child.props.label, value: child.props.value });
      });

      componentData.push(items);
      selectedIndexes.push(selectedIndex);
    });

    this.state = { componentData, selectedIndexes, };

    this.onChange = this.onChange.bind(this);
  }

  onChange({ nativeEvent }) {
    // Call any change handlers on the component itself
    if (this.props.onChange) {
      this.props.onChange(nativeEvent);
    }

    if (this.props.valueChange) {
      this.props.valueChange(nativeEvent);
    }

    // Call any change handlers on the child component picker that changed
    // if it has one. Doing it this way rather than storing references
    // to child nodes and their onChage props in _stateFromProps because
    // React docs imply that may not be a good idea.
    React.Children.forEach(this.props.children, function (child, idx) {
      if (idx === nativeEvent.component && child.props.onChange) {
        child.props.onChange(nativeEvent);
      }
    });

    const nativeProps = {
      componentData: this.state.componentData,
    };

    nativeProps.selectedIndexes = this.state.selectedIndexes;
    this.refs[PICKER_REF].setNativeProps(nativeProps);
  }

  render() {
    return (
      <View style={this.props.style}>
        <RNMultiPicker
          ref={PICKER_REF}
          style={styles.multipicker}
          selectedIndexes={this.state.selectedIndexes}
          componentData={this.state.componentData}
          onChange={this.onChange}/>
      </View>
    );
  }
}

export class Group extends React.Component {
  static propTypes = {
    items: PropTypes.array,
    selectedIndex: PropTypes.number,
    onChange: PropTypes.func,
  };

  render() {
    return null;
  }
}



// Represents an item in a picker section: the `value` is used for setting /
// getting selection
export class Item extends React.Component {
  static propTypes = {
    value: PropTypes.any.isRequired, // string or integer basically
    label: PropTypes.string.isRequired, // for display
  };

  render() {
    return null;
  }
}
