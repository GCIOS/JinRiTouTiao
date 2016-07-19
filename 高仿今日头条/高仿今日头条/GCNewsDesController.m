//
//  GCNewsDesController.m
//  dangMeiTouTiao
//
//  Created by 高崇 on 16/4/18.
//  Copyright © 2016年 LieLvWang. All rights reserved.
// publishcommont 发表评论


#define ContentViewHeight (kScreenH - 64 - ToolBarHeigth)
#define MiddleViewHeight 160

#define ToolBarHeigth 44
#define ShareBtnWidth 50
#define CommentViewHeight 150


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


#import "GCNewsDesController.h"
#import "Masonry.h"



@interface GCNewsDesController ()<UIWebViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *secondTableView;

@property (nonatomic, strong) UILabel *middleView;
@property (nonatomic, strong) UILabel *secondMiddleView;

@end

@implementation GCNewsDesController


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupWebView];
    [self setupToolBar];

}

- (void)setupToolBar
{
    
    UIView *toolBar = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];

        [self.view insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(ToolBarHeigth);
        }];
        view;
    });
    
    UIButton *shareBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"home_011daohangfenxiang"] forState:UIControlStateNormal];
        
        [toolBar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(toolBar);
            make.top.equalTo(toolBar);
            make.width.mas_equalTo(ShareBtnWidth);
            make.height.mas_equalTo(ToolBarHeigth);
        }];
        view;
    });
    UIButton *CollectionBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"home_hongshoucang"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"home_hongshoucang_s"] forState:UIControlStateSelected];
        
        [toolBar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shareBtn.mas_left);
            make.top.equalTo(toolBar);
            make.width.mas_equalTo(ShareBtnWidth);
            make.height.mas_equalTo(ToolBarHeigth);
        }];
        view;
    });
    UIButton *commentNumBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = [UIColor redColor];
        [view setTitle:@"点我" forState:0];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        [view addTarget:self action:@selector(commentNumBtn_click:) forControlEvents:UIControlEventTouchUpInside];

        [toolBar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(CollectionBtn.mas_left);
            make.top.equalTo(toolBar);
            make.width.mas_equalTo(ShareBtnWidth);
            make.height.mas_equalTo(ToolBarHeigth);
        }];
        view;
    });
    
    UIButton *xiePingLunBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 0.5;
        
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        view.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        [view setTitle:@"写评论..." forState:UIControlStateNormal];
        
        [toolBar addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toolBar.mas_left).offset(10);
            make.right.equalTo(commentNumBtn.mas_left).offset(-10);
            make.top.equalTo(toolBar.mas_top).offset(5);
            make.bottom.equalTo(toolBar.mas_bottom).offset(-5);
        }];
        view;
    });

    
}

- (void)setupWebView
{
    // 1 webView
    self.webView = ({
        
        UIWebView *view = [[UIWebView alloc] init];
        [view addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
        view.delegate = self;
        view.scrollView.delegate = self;
        view.paginationMode = UIWebPaginationModeTopToBottom;
        view.pageLength = 15;
        [self.view insertSubview:view atIndex:0];
        view.frame = CGRectMake(0, 64, kScreenW, ContentViewHeight);

        view;
    });
    
    
    // 1.2 加载数据
    NSURL *url = [NSURL URLWithString:@"http://api.dang.xn--fiqs8s/_/api/acon/year2016/mouth7/day18/7aa2903e-130f-497b-b76b-9e2cc2c56de5.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    
    //2 tableView
    self.tableView = ({
        UITableView *view = [[UITableView alloc] init];
        view.hidden = YES;
        view.delegate = self;
        view.dataSource = self;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.frame = CGRectMake(0,  ContentViewHeight, kScreenW, ContentViewHeight);
        
        view.tableHeaderView = self.middleView;
        [_webView.scrollView addSubview:view];
        view;
    });
}



#define UpFrame CGRectMake(0, 0, kScreenW, kScreenH - ToolBarHeigth)
#define DownFrame CGRectMake(0, kScreenH, kScreenW, kScreenH - ToolBarHeigth)


- (void)secondTableViewUp
{

    self.secondTableView.frame = DownFrame;
    self.secondTableView.hidden = NO;
    [self.secondTableView setContentOffset:CGPointMake(0, MiddleViewHeight) animated:NO];

    [UIView animateWithDuration:0.25 animations:^{
        self.secondTableView.frame = UpFrame;
    }];
}
- (void)secondTableViewDown
{
    [UIView animateWithDuration:0.25 animations:^{
        self.secondTableView.frame = DownFrame;
    } completion:^(BOOL finished) {
        self.secondTableView.hidden = YES;
        [self.secondTableView setContentOffset:CGPointZero];
        
    }];
}

#pragma mark - 点击事件

- (void)commentNumBtn_click:(UIButton *)btn
{
    
    if (self.webView.scrollView.contentOffset.y < self.webView.scrollView.contentSize.height - ContentViewHeight) {// 此时相关阅读还没出现在屏幕
        if (self.secondTableView.hidden == NO){
            [self secondTableViewDown];
        }else{
            [self secondTableViewUp];
        }
    }else{
        
        if (self.webView.scrollView.contentOffset.y == self.webView.scrollView.contentSize.height) {//说明webView滚动到了底部
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height - ContentViewHeight) animated:YES];
        }else{
            [self.tableView setContentOffset:CGPointMake(0, MiddleViewHeight) animated:NO];

            [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height) animated:YES];
        }
    }
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
        NSLog(@"%p --%p---%p-- %f --%f", self.webView.scrollView, self.tableView, scrollView, scrollView.contentOffset.y, self.tableView.contentOffset.y);
        NSLog(@"%f  ++ %f", self.webView.scrollView.contentSize.height, self.webView.scrollView.contentOffset.y);
    
    if (scrollView == self.webView.scrollView) {
        self.tableView.scrollEnabled = NO;
        if (self.webView.scrollView.contentOffset.y == self.webView.scrollView.contentSize.height) {
            self.tableView.scrollEnabled = YES;
        }
    }
    
    if (self.webView.scrollView.contentOffset.y > 0) {
        self.webView.scrollView.bounces = NO;
    }else{
        self.webView.scrollView.bounces = YES;
    }
    
    if (self.tableView.contentOffset.y > 0) {
        self.tableView.bounces = YES;
        self.webView.scrollView.scrollEnabled = NO;
    }else{
        self.tableView.bounces = NO;
        self.webView.scrollView.scrollEnabled = YES;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.secondTableView && scrollView.contentOffset.y <= -33) {
        [self commentNumBtn_click:nil];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, ContentViewHeight, 0);
    self.tableView.hidden = NO;
    self.tableView.frame = CGRectMake(0, webView.scrollView.contentSize.height, kScreenW, ContentViewHeight);

    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.tableView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height, kScreenW, ContentViewHeight);
}

#pragma mark - tableView 代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1 取出模型数据
    
    //2 创建单元格
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    //3 设置单元格数据
    cell.textLabel.text = [NSString stringWithFormat:@"高仿今日头条详情页效果 --- %zd", indexPath.row];
    
    //4 返回单元格
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - 懒加载

- (UITableView *)secondTableView
{
    if (!_secondTableView) {
        _secondTableView = ({
            UITableView *view = [[UITableView alloc] init];
            view.delegate = self;
            view.dataSource = self;
            view.separatorStyle = UITableViewCellSeparatorStyleNone;
            view.frame = CGRectMake(0, 0, kScreenW, ContentViewHeight);
            view.hidden = YES;
            [self.view addSubview:view];
            view;
        });
        _secondTableView.tableHeaderView = self.secondMiddleView;
    }
    return _secondTableView;
}

- (UILabel *)middleView
{
    if (!_middleView) {
        _middleView = [UILabel new];
        _middleView.text = @"相关阅读新闻";
        _middleView.textAlignment = NSTextAlignmentCenter;
        _middleView.font = [UIFont systemFontOfSize:22];
        _middleView.backgroundColor = [UIColor yellowColor];
        _middleView.frame = CGRectMake(0, 0, kScreenW, MiddleViewHeight);
    }
    return _middleView;
}

- (UILabel *)secondMiddleView
{
    if (!_secondMiddleView) {
        _secondMiddleView = [UILabel new];
        _secondMiddleView.text = @"相关阅读新闻";
        _secondMiddleView.textAlignment = NSTextAlignmentCenter;
        _secondMiddleView.font = [UIFont systemFontOfSize:22];
        _secondMiddleView.backgroundColor = [UIColor yellowColor];
        _secondMiddleView.frame = CGRectMake(0, 0, kScreenW, MiddleViewHeight);
    }
    return _secondMiddleView;
}

- (void)dealloc
{
    
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];

}

@end
