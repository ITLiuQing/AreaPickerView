//
//  ViewController.m
//  AreaPickerView
//
//  Created by Harriet on 2018/7/9.
//  Copyright © 2018年 Harriet. All rights reserved.
//

#import "ViewController.h"
#import <FMDatabase.h>
#import <MJExtension.h>
#import "DHAreasModel.h"
#import "DHAreaPickerView.h"
#import "IQKeyboardManager.h"

@interface ViewController ()<DHAreaPickerViewDelegate>

@property (nonatomic, strong) DHAreasModel *areasModel;
@property (nonatomic, strong) DHAreaPickerView * pickerTypeView;
//用于接收数据
@property (nonatomic, strong) UILabel *areaLabel;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //取出区域数据
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:areaPath];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM AllAreasTable"];
    [dataBase open];
    FMResultSet *result = [dataBase executeQuery:queryString];
    while ([result next]) {

        NSDictionary *areasDict = [result objectForKeyedSubscript:@"json"];
        NSLog(@"%@",areasDict);
        self.areasModel = [DHAreasModel mj_objectWithKeyValues:areasDict];
    }
    
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 35)];
    self.areaLabel.textAlignment = NSTextAlignmentCenter;
    self.areaLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.areaLabel];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 200, 80, 44)];
    [btn setTitle:@"选择区域" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:btn];
    
    if (!self.pickerTypeView)
    {
        self.pickerTypeView =[[DHAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    }
    self.pickerTypeView.delegate = self;
    self.pickerTypeView.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.pickerTypeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pickerTypeView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.pickerTypeView.titleLabel.textAlignment = NSTextAlignmentRight;
    self.pickerTypeView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.pickerTypeView setTitleEdgeInsets:UIEdgeInsetsMake(0, 90, 0, 30)];
    self.pickerTypeView.areasModel = self.areasModel;
    self.pickerTypeView.enabled = YES;
    [self.pickerTypeView setBackgroundColor:[UIColor blueColor]];
    [btn addSubview:self.pickerTypeView];
    [self.pickerTypeView addTarget:self action:@selector(nationViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nationViewOnClick:(id)sender{
    [sender becomeFirstResponder];
}

- (void)selectType:(NSString *)selectTitle
{
    NSLog(@"provinceId:%@,cityId:%@,countryId:%@",self.pickerTypeView.provinceId,self.pickerTypeView.cityId,self.pickerTypeView.countryId);
    self.areaLabel.text = selectTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
