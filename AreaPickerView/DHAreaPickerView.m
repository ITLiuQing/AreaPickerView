//
//  DHAreaPickerView.m
//  AreaPickerView
//
//  Created by Harriet on 2018/7/9.
//  Copyright © 2018年 Harriet. All rights reserved.
//

#import "DHAreaPickerView.h"
#import "DHAreasModel.h"

// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface DHAreaPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray <DHAreasProvinceModel *>*provinceArray;
@property (nonatomic, strong) NSMutableArray <DHAreasCityModel *>*cityArray;
@property (nonatomic, strong) NSMutableArray<DHAreasCountryModel *> *countryArray;

@property (nonatomic, assign) NSInteger selectRow0;
@property (nonatomic, assign) NSInteger selectRow1;
@property (nonatomic, assign) NSInteger selectRow2;

@end

@implementation DHAreaPickerView

- (BOOL) canBecomeFirstResponder {
    
    if ([self.delegate respondsToSelector:@selector(pickViewWillBecomeFirstResponder:)]) {
        [self.delegate pickViewWillBecomeFirstResponder:self];
    }
    return YES;
}

- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

- (NSMutableArray *)countryArray
{
    if (!_countryArray) {
        _countryArray = [[NSMutableArray alloc] init];
    }
    return _countryArray;
}

- (UIToolbar*)inputAccessoryView {
    
    if (_inputAccessoryView == nil)
    {
        UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnResignFirstResponder)];
        leftItem.tintColor = [UIColor redColor];//设置取消按钮字体颜色
        //空白
        UIBarButtonItem *btn4=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnResignFirstResponder)];
        rightItem.tintColor = [UIColor redColor];//设置确定按钮字体颜色
        toolBar.items = @[leftItem,btn4,rightItem];
        
        return toolBar;
    }
    
    return _inputAccessoryView;
}

- (UIPickerView *)inputView{
    if (_inputView == nil) {
        //初始化数据
        self.selectRow0 = 0;
        self.selectRow1 = 0;
        self.selectRow2 = 0;
        
        self.provinceArray = (NSMutableArray <DHAreasProvinceModel *>*)self.areasModel.content;
        self.cityArray = (NSMutableArray <DHAreasCityModel *> *)self.provinceArray[0].childList;
        self.countryArray = (NSMutableArray <DHAreasCountryModel *> *)self.cityArray[0].childList;
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor whiteColor];//设置pickerView的背景颜色
        return pickerView;
    }
    return _inputView;
}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
/**
 *  设置pickerView的列数
 *  @return pickerView的列数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

/**
 *  设置每一列显示的行数
 *  @param component  列
 *  @return 每列的行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else{
        return self.countryArray.count;
    }
}

/**
 *  设置每一列的宽度
 *  @param component  列
 *  @return 每列的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kScreenWidth/3;
}

/**
 *  设置每一行的高度
 *  @param component  列
 *  @return 每一行的高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

/**
 *  设置每一行的title
 *  @param component  列
 *  @return 每一行的title
 */
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray[row].name;
    }else if (component == 1){
        return self.cityArray[row].name;
    }else{
        return self.countryArray[row].name;
    }
}

/**
 *  pickerView选中代理
 *  @param row        选中的row
 *  @param component  列
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component==0)
    {
        self.selectRow0 = row;
        self.selectRow1 = 0;
        self.selectRow2 = 0;
        
        self.provinceArray = (NSMutableArray <DHAreasProvinceModel *> *)self.areasModel.content;
        self.cityArray =  (NSMutableArray <DHAreasCityModel*>*)self.provinceArray[row].childList;
        self.countryArray = (NSMutableArray<DHAreasCountryModel*>*)self.cityArray[0].childList;
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];//默认选择row 0
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    if(component==1)
    {
        self.selectRow1 = row;
        self.selectRow2 = 0;
        
        self.countryArray = (NSMutableArray<DHAreasCountryModel*>*)self.cityArray[row].childList;
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    if(component==2){
        self.selectRow2 = row;
    }
}

//确认按钮点击事件
- (void)rightBtnResignFirstResponder
{
    NSString * appendString = @"";
    NSString *provinceTitle = self.provinceArray[self.selectRow0].name;
    self.provinceId = self.provinceArray[self.selectRow0].privinceId;
    NSString *cityTitle = self.cityArray[self.selectRow1].name;
    self.cityId = self.cityArray[self.selectRow1].cityId;
    NSString *countryTitle = self.countryArray[self.selectRow2].name;
    self.countryId = self.countryArray[self.selectRow2].countryId;
    appendString = [NSString stringWithFormat:@"%@ %@ %@",provinceTitle,cityTitle,countryTitle];
    if ([self.delegate respondsToSelector:@selector(selectType:)])
    {
        [self.delegate selectType:appendString];
    }
    
    [self endEditing:YES];
}

//取消按钮点击事件
- (void)leftBtnResignFirstResponder
{
    [self endEditing:YES];
}



@end
