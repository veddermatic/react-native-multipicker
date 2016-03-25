//
//  RNPickerManager.m
//
//  Created by David Vedder on 4/16/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNMultiPickerManager.h"

#import "RCTBridge.h"
#import "RCTConvert.h"
#import "RNMultiPicker.h"

@implementation RNMultiPickerManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[RNMultiPicker alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_VIEW_PROPERTY(selectedIndexes, NSNumberArray);
RCT_EXPORT_VIEW_PROPERTY(componentData, NSArray);
RCT_EXPORT_VIEW_PROPERTY(componentLoopingRows, NSArray);

- (NSDictionary *)constantsToExport
{
  RNMultiPicker *view = [[RNMultiPicker alloc] init];

  return @{
    @"ComponentHeight": @(CGRectGetHeight(view.frame)),
    @"ComponentWidth": @(CGRectGetWidth(view.frame))
  };
}

@end
