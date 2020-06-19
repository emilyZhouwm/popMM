//
//  ViewController.m
//  popM
//
//  Created by zwm on 16/6/23.
//  Copyright © 2016年 zwm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGFloat _bottomH;
    CGFloat _headH;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _headH = 50;
    [_bottomView layoutIfNeeded];
    CGFloat h = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0) {
            h = 38;
        }
    }
    _bottomH = _bottomView.frame.size.height + h;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_headH, 0, _bottomH, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _headH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _headH)];
    v.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headH - 1, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.6];
    [v addSubview:line];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.view.frame.size.width - 32, _headH)];
    l.text = @"循环播放";
    [v addSubview:l];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (offset > 0) {
        _heightLayout.constant = _bottomH + offset;
    } else {
        if (_heightLayout.constant != _bottomH) {
            if (_heightLayout.constant > _bottomH + 10) {
                _heightLayout.constant = _bottomH;
                [_bottomView setNeedsLayout];
                [UIView animateWithDuration:0.25 animations:^{
                    [_bottomView layoutIfNeeded];
                }];
            } else {
                _heightLayout.constant = _bottomH;
            }
        }
    }
    if (scrollView.contentOffset.y <= 0) {
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_headH - scrollView.contentOffset.y, 0, _bottomH, 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -60) {
        [self hideAction];
    }
}

#pragma mark - action
- (IBAction)showBtnAction:(UIButton *)sender
{
    _topLayout.priority = 750;
    [_tableView setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView.superview layoutIfNeeded];
        _backView.alpha = 1;
    }];
}

- (IBAction)hideAction
{
    _topLayout.priority = 249;
    [_tableView setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView.superview layoutIfNeeded];
        _backView.alpha = 0;
    }];
}

@end
