//
//  ViewController.m
//  SearchDemo
//
//  Created by Amuxiaomu on 16/7/27.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
#import "UserDTO.h"
#import "NSString+pinyin.h"
#import "UIView+Frame.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
// TextField  当做searchBar
@property (weak, nonatomic) IBOutlet  UITextField * searchBar;

// tableView
@property (weak, nonatomic) IBOutlet UITableView * tableView;

// 存储模型数组
@property (nonatomic, strong) NSMutableArray * storeUserDTOList;

// 搜索数组
@property (nonatomic, strong) NSMutableArray * searchUserDTOList;

// 是否在搜索状态
@property (nonatomic, assign) BOOL isSearchState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

- (void)setupUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

// 监听方法
- (void)textChange:(NSNotification *)note{
    
    UITextField * textField = (UITextField *)[note object];
    
    // 如果项目大, 搜索的地方多 , 就要使用多线程, 然后在刷新tableView 的时候 回到主线程
    [self startSearch:textField.text];
}

// 开始所搜
- (void)startSearch:(NSString *)string{
    if (self.searchUserDTOList.count > 0) {
        
        [self.searchUserDTOList removeAllObjects];
    }
    
    // 开始搜索
    NSString * key = string.lowercaseString;
    NSMutableArray * tempArr = [NSMutableArray array];
    
    if (![key isEqualToString:@"" ] && ![key isEqual:[NSNull null]]) {
        
        [self.storeUserDTOList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UserDTO * dto = self.storeUserDTOList[idx];
            
            //担心框架有事后为误转, 再次都设置转为小写
            NSString * name = dto.name.lowercaseString;
            NSString * namePinyin = dto.namePinYin.lowercaseString;
            NSString * nameFirstLetter = dto.nameFirstLetter.lowercaseString;
            
            NSRange rang1 = [name rangeOfString:key];
            if (rang1.length > 0) { // 比牛  -比
                
                [tempArr addObject:dto];
            }else {
                if ([nameFirstLetter containsString:key]) {
                    
                    [tempArr addObject:dto];
                }else { //二首
                    if ([nameFirstLetter containsString:[key substringToIndex:1]]) {
                        
                        if ([namePinyin containsString:key]) {
                            [tempArr addObject:dto];
                        }
                    }
                }
            }
            
        }];
        
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![self.searchUserDTOList containsObject:tempArr[idx]]) {
                
                [self.searchUserDTOList addObject:tempArr[idx]];
            }
        }];
        
        self.isSearchState = YES;
    
    }else{
        
        self.isSearchState = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 如果想自定义更多, 就把noResultLab 换成一个大的BJView, 里面在填充很多小空件
    UILabel * noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    noResultLab.font = [UIFont systemFontOfSize:20];
    noResultLab.textColor = [UIColor lightGrayColor];
    noResultLab.hidden = YES;
    noResultLab.text = @"抱歉! 没有搜索到相关数据";
    tableView.backgroundView = noResultLab;
    
    if (_isSearchState) {
        
        if (self.searchUserDTOList.count > 0) {
            
            noResultLab.hidden = YES;
            
            return self.searchUserDTOList.count;
        }else {
            
            noResultLab.hidden = NO;
            
            return 0;
        }
    }else {
        
        return self.storeUserDTOList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UserDTO * dto = nil;
    
    if (_isSearchState) {
        
        dto = self.searchUserDTOList[indexPath.row];
    }else {
        
        dto = self.storeUserDTOList[indexPath.row];
    }
    
    cell.textLabel.text = dto.name;
    
    return cell;
}


/**
 *  制造假数据
 */

- (void)loadData{
    
    NSArray * nameArr = @[@"中国",@"联想",@"百胜2000基数",@"苹果电脑",@"Iphone6s",@"中关村",@"东方明珠",@"人民广场",@"火车站",@"MicroSoft",@"Oracle",@"凯迪拉克",@"甲骨文"];
    
    for (int i = 0; i < nameArr.count; i++) {
        
        UserDTO * dto = [[UserDTO alloc] init];
        
        // 转拼音
        NSString * PinYin = [nameArr[i] transformToPinyin];
        
        // 首字母
        NSString * FirstLetter = [nameArr[i] transformToPinyinFirstLetter];
        
        dto.name = nameArr[i];
        dto.namePinYin = PinYin;
        dto.nameFirstLetter = FirstLetter;
        
        [self.storeUserDTOList addObject:dto];
    }
    
    [self.tableView reloadData];
}

#pragma mark
#pragma mark - 懒加载

- (NSMutableArray *)storeUserDTOList{
    if (_storeUserDTOList == nil) {
        _storeUserDTOList = [[NSMutableArray alloc] init];
    }
    return _storeUserDTOList;
}

- (NSMutableArray *)searchUserDTOList{
    if (_searchUserDTOList == nil) {
        _searchUserDTOList = [[NSMutableArray alloc] init];
    }
    return _searchUserDTOList;
}
@end



















