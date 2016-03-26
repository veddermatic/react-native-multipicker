//
//  Created by David Vedder on 4/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNMultiPicker.h"

#import "RCTConvert.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"
#import "UIView+React.h"


@interface RNMultiPicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@end

const int MAX_LOOPING_ROWS = 16384;

@implementation RNMultiPicker
{
  RCTEventDispatcher *_eventDispatcher;
  NSArray *_selectedIndexes;
  NSArray *_componentData;
  NSArray *_componentLoopingRows;
  BOOL _selectedIndexesHaveChanged;
  BOOL _use_animation;
}

#pragma mark - init method
- (id)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
  if (self = [super initWithFrame:CGRectZero]) {
    _eventDispatcher = eventDispatcher;
    self.delegate = self;
    
    _selectedIndexesHaveChanged = NO;
    _use_animation = NO;
  }
  return self;
}


#pragma mark - Exposed property setters

- (void)setSelectedIndexes:(NSArray *)selectedIndexes
{
  if (![_selectedIndexes isEqualToArray:selectedIndexes]) {
    _selectedIndexes = [selectedIndexes copy];
    _selectedIndexesHaveChanged = YES;
    _use_animation = NO;
  }
}

- (void)setComponentData:(NSArray *)componentData
{
  if (![_componentData isEqualToArray:componentData]) {
    _componentData = [componentData copy];
    [self setNeedsLayout];
  }
}

- (void)setComponentLoopingRows:(NSArray *)componentLoopingRows
{
  if (![_componentLoopingRows isEqualToArray:componentLoopingRows]) {
    _componentLoopingRows = [componentLoopingRows copy];
  }
}

#pragma mark - Look, I'm helping!
/**
 * Returns whether a picker component is looping rows or not
 */
- (BOOL)hasLoopingRows:(NSInteger)component
{
  return [[_componentLoopingRows objectAtIndex:component] boolValue];
}

/*
 * Returns the number of base rows for a picker component
 */
- (NSInteger)numberOfBaseRowsForComponent:(NSInteger)component
{
  return [[_componentData objectAtIndex:component] count];
}

/**
 * Returns the normalized row index for a component
 */
- (NSInteger)normalizeRowIndex:(NSInteger)row forComponent:(NSInteger)component
{
  return row % [self numberOfBaseRowsForComponent:component];
}

/**
 * Returns the looping offset based on number of base rows
 */
- (NSInteger)loopingRowsOffsetForComponent:(NSInteger)component
{
  return (MAX_LOOPING_ROWS / 2) - (MAX_LOOPING_ROWS / 2) % [self numberOfBaseRowsForComponent:component];
}

/**
 *  Returns the row index adjusted or as is based on whether the picker component has looping rows or not
 *  and whether the row index is within the middle row sequence.
 */
- (NSInteger)adjustOrKeepRowIndex:(NSInteger)row forComponent:(NSInteger)component
{
  return [ self hasLoopingRows:component] ? row % [self numberOfBaseRowsForComponent:component] + [self loopingRowsOffsetForComponent:component] : row;
}

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
  return [[self dataForComponent:component] objectAtIndex:(row % [self numberOfBaseRowsForComponent:component])];
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

/**
 * Called when props have been changed. 
 * Used for resetting the indices of components with looping rows esp. when the picker is initialized.
 */
- (void)didSetProps:(NSArray<NSString *> *)changedProps
{
  if (changedProps.count > 0) {
    if ([changedProps containsObject:@"componentLoopingRows"]) {
      // Reset indices for components with looping rows
      for (NSInteger i = 0; i < self.numberOfComponents; i++) {
        if ([self hasLoopingRows:i]) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self selectRow:[self adjustOrKeepRowIndex:[self selectedRowInComponent:i] forComponent:i] inComponent:i animated:NO];
          });
        }
      }
    }
    
    if ([changedProps containsObject:@"selectedIndexes"] && _selectedIndexesHaveChanged) {
      // TODO: see if this loop to check if we should bother updating is even
      // needed. React probably only updates us if we *do* need to update.
      for (NSInteger i = 0; i < self.numberOfComponents; i++) {
        NSInteger currentSelected = [self selectedRowInComponent:i];
        NSInteger checkVal = [self adjustOrKeepRowIndex:[[_selectedIndexes objectAtIndex:i] integerValue] forComponent:i];
        if (i < _selectedIndexes.count && currentSelected != checkVal ) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self selectRow:checkVal inComponent:i animated:_use_animation];
          });
        }
      }
      _selectedIndexesHaveChanged = NO;
      _use_animation = YES;
    }
  }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [self hasLoopingRows:component] ? MAX_LOOPING_ROWS : [self numberOfBaseRowsForComponent:component];
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
  // Normalize new row index
  NSInteger newIndex = [self normalizeRowIndex:row forComponent:component];
  // If needed select adjusted row without animating the transition
  NSInteger loopingRowsOffset = [self loopingRowsOffsetForComponent:component];
  if ( [self hasLoopingRows:component] && (row < loopingRowsOffset || row >= loopingRowsOffset + [self numberOfBaseRowsForComponent:component])) {
    [pickerView selectRow:[self adjustOrKeepRowIndex:row forComponent:component] inComponent:component animated:NO];
  }
  
  NSDictionary *event = @{
    @"target": self.reactTag,
    @"newIndex": @(newIndex),
    @"component": @(component),
    @"newValue": [self valueForRow:row inComponent:component]
  };

  [_eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

@end
