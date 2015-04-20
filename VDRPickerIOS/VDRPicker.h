//
//  VDRPickerView.h
//  VedderPicker
//
//  Created by David Vedder on 4/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCTEventDispatcher;

@interface VDRPicker : UIPickerView

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy) NSArray *selectedIndexes;
@property (nonatomic, copy) NSArray *componentData;

@end
