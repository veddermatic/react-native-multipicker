# react-native-multipicker

A UIPickerView implementation that allows you to have multiple
components in your picker.

##Example
You can make a basic one like so:

```javascript
var MultiPickerIOS = require('react-native-multipicker');
var { Group, Item } = MultiPickerIOS;

var MultiPickerExampleApp = React.createClass({
  render() {
    return (
      <MultiPickerIOS style={styles.picker} onChange={this._someOnChange}>
          <Group selectedValue={this.state.currentWord} onChange={this._someOtherOnChange}>
              <Item value="How" label="How" />
              <Item value="now" label="now" />
              <Item value="brown" label="brown" />
              <Item value="cow" label="cow" />
          </Group>
          <Group selectedValue={this.state.curentCount}>
              <Item value="Uno" label="Uno" />
              <Item value="Dos" label="Dos" />
              <Item value="Tres" label="Tres" />
              <Item value="Four" label="Four" />
          </Group>
      </MultiPickerIOS>
    )
  }
});
```

##Getting started
1. `npm install react-native-multipicker --save`
2. In XCode, in the project navigator (the folder icon in the left pane), right click the folder `Libraries` ➜ choose `Add Files to [your project's name]`
3. Browse to `[your project's node_modules]/react-native-multipicker/` and choose `RNMultiPicker.xcodeproj`, and click `Add`
4. In the XCode project navigator, select your project, select the Build Phases tab and in the `Link Binary With Libraries` drop down section add `libRNMultiPickerIOS.a`
