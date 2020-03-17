//
//  Created by David Vedder on 4/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <React/RCTComponent.h>

@interface RNMultiPicker : UIPickerView

@property (nonatomic, copy) NSArray *selectedIndexes;
@property (nonatomic, copy) NSArray *componentData;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;

@end
