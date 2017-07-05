//
//  Created by David Vedder on 4/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNMultiPicker.h"

#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>


@interface RNMultiPicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation RNMultiPicker
{
  RCTEventDispatcher *_eventDispatcher;
  NSArray *_selectedIndexes;
  NSArray *_componentData;
  int _use_animation;
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


#pragma mark - Exposed property setters

- (void)setSelectedIndexes:(NSArray *)selectedIndexes
{

  if (![_selectedIndexes isEqualToArray:selectedIndexes]) {
    BOOL animate = (_use_animation != 0);

    _selectedIndexes = [selectedIndexes copy];
    // TODO: see if this loop to check if we should bother updating is even
    // needed. React probably only updates us if we *do* need to update.
    for (NSInteger i = 0; i < self.numberOfComponents; i++) {
      NSInteger currentSelected = [self selectedRowInComponent:i];
      NSInteger checkVal = [[_selectedIndexes objectAtIndex:i] integerValue];
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
  if (![_componentData isEqualToArray:componentData]) {
    _componentData = [componentData copy];
    [self setNeedsLayout];
  }
}

#pragma mark - Look, I'm helping!

/**
 *  Returns the array of dictionaries that populates a given picker component
 */
- (NSArray *)dataForComponent:(NSInteger)component
{
  return  [_componentData objectAtIndex:component];
}

/**
 * Returns the dictionay
 */
- (NSDictionary *)dataForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [[self dataForComponent:component] objectAtIndex:row];
}

/**
 * Returns the value for the row
 */
- (id)valueForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [self dataForRow:row inComponent:component][@"value"];
}

/**
 * Returns the label for the row
 */
- (NSString *)labelForRow:(NSInteger)row inComponent:(NSInteger)component
{
  return [self dataForRow:row inComponent:component][@"label"];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [[_componentData objectAtIndex:component] count];
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
