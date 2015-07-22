# react-native-multi-picker

A UIPickerView implementation that allows you to have multiple
components in your picker.

You can make a basic one like so:

```javascript
var MultiPickerIOS = require('react-native-multi-picker');
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
