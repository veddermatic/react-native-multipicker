//
//  VDRPickerView.m
//  VedderPicker
//
//  Created by David Vedder on 4/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved. I guess. I'm not sure
//  how the whole thing works.
//

#import "VDRPicker.h"

#import "RCTConvert.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"
#import "UIView+React.h"



@interface VDRPicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

// copying the react-native Picker way of doing this...
@implementation VDRPicker
{
  RCTEventDispatcher *_eventDispatcher;
  NSArray *_selectedIndexes;
  NSArray *_componentData;
  int _use_animation;
}


#pragma mark - Exposed property setters

- (void)setSelectedIndexes:(NSArray *)selectedIndexes
{

  if (_selectedIndexes != selectedIndexes) {
    BOOL animate = (_use_animation != 0);
    _selectedIndexes = [selectedIndexes copy];
    // TODO: see if this loop to check if we should bother updating is even
    // needed. React probably only updates us if we *do* need to update.
    for (NSInteger i = 0; i < self.numberOfComponents; i++) {
      NSInteger currentSelected = [self selectedRowInComponent:i];
      NSInteger checkVal = [_selectedIndexes[i] integerValue];
      if (i < _selectedIndexes.count && currentSelected != checkVal ) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self selectRow:checkVal inComponent:i animated:animate];
        });
      }
    }
    _use_animation = 1;
  }
}

- (void)setComponentData:(NSArray *)componentData
{
  if (_componentData != componentData) {
    _componentData = [componentData copy];
    [self setNeedsLayout];
  }
}

#pragma mark - init method
- (id)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
  if (self = [super initWithFrame:CGRectZero]) {
    _eventDispatcher = eventDispatcher;
    self.delegate = self;
    _use_animation = 0;
  }
  return self;
}

#pragma mark - Look, I'm helping!
- (NSArray *)dataForComponent:(NSInteger)component
{
  return  _componentData[component];
}

- (NSDictionary *)dataForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [self dataForComponent:component][row];
}

- (id)valueForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [self dataForRow:row inComponent:component][@"value"];
}

- (NSString *)labelForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [self dataForRow:row inComponent:component][@"label"];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [_componentData[component] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return [_componentData count];
}

#pragma mark - UIPickerDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self labelForRow:row inComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  NSDictionary *event = @{
                          @"target": self.reactTag,
                          @"newIndex": @(row),
                          @"component": @(component),
                          @"newValue": [self valueForRow:row inComponent:component]
                          };
  
  [_eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

@end
