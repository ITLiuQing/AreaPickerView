//
//  DHAreaPickerView.h
//  AreaPickerView
//
//  Created by Harriet on 2018/7/9.
//  Copyright © 2018年 Harriet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHAreasModel;

@class DHAreaPickerView;
@protocol DHAreaPickerViewDelegate <NSObject>

@optional

- (void) selectType:(NSString*)selectTitle;

- (void) pickViewWillBecomeFirstResponder:(DHAreaPickerView *)pickView;

@end

@interface DHAreaPickerView : UIButton

@property (nonatomic, weak) id<DHAreaPickerViewDelegate> delegate;
@property (nonatomic, strong) DHAreasModel *areasModel;
@property (nonatomic,strong,readwrite) __kindof UIView *inputView;
@property (nonatomic,strong,readwrite) __kindof UIView *inputAccessoryView;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countryId;

@end
