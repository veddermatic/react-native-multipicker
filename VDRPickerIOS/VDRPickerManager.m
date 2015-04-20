//
//  VDRPickerManager.m
//  VedderPicker
//
//  Created by David Vedder on 4/16/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "VDRPickerManager.h"

#import "RCTBridge.h"
#import "RCTConvert.h"
#import "VDRPicker.h"

@implementation VDRPickerManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[VDRPicker alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_VIEW_PROPERTY(selectedIndexes, NSNumberArray);
RCT_EXPORT_VIEW_PROPERTY(componentData, NSArray)

- (NSDictionary *)constantsToExport
{
  VDRPicker *pv = [[VDRPicker alloc] init];
  return @{
           @"ComponentHeight": @(CGRectGetHeight(pv.frame)),
           @"ComponentWidth": @(CGRectGetWidth(pv.frame))
           };
}

@end
