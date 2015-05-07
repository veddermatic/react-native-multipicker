# react-native-multipicker

A UIPickerView proof of concept implementation that allows you to have multiple components in your picker.

You can make a basic one like so:

    <VPickerIOS style={styles.picker} onChange={this._someOnChange}>
        <VPickerComponent selectedValue={this.state.currentWord} onChange={this._someOtherOnChange}>
            <VPickerItem value="How" label="How" />
            <VPickerItem value="now" label="now" />
            <VPickerItem value="brown" label="brown" />
            <VPickerItem value="cow" label="cow" />
        </VPickerComponent>
        <VPickerComponent selectedValue={this.state.curentCount}>
            <VPickerItem value="Uno" label="Uno" />
            <VPickerItem value="Dos" label="Dos" />
            <VPickerItem value="Tres" label="Tres" />
            <VPickerItem value="Four" label="Four" />
        </VPickerComponent>
    </VPickerIOS>

You can also set the `controlled` prop on `VPickerIOS` to have your selected indexes pushed back to the native component in case you need to validate selection:

     <VPickerIOS style={styles.picker} onChange={this._someOnChange} controlled={true}>
        ...

Please note that this is still a work in progress, and you probalby should not use this unless you are just looking at the code for fun.

I have a test project showing a simple and "complex" picker [here](https://github.com/veddermatic/VDRPickerTestProject).
