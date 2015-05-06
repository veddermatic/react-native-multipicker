# react-native-multipicker

A UIPickerView proof of concept implementation that allows you to have multiple components in your picker.

You can make one like so:

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

Please note that this is still a work in progress, and you probalby should not use this unless you are just looking at the code for fun.
