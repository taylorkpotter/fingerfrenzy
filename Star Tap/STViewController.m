//
//  STViewController.m
//  Star Tap
//
//  Created by John Clem on 2/11/14.
//  Copyright (c) 2014 Taylor Potter. All rights reserved.
//

#import "STViewController.h"

@interface STViewController ()

@property (nonatomic, strong) NSMutableArray *topSquares, *bottomSquares;
@property (nonatomic, strong) UIView *squareWithStar;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, readwrite) NSInteger shotClockTimeLeft, score;
@property (nonatomic, strong) NSTimer *shotClock;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _topSquares = [NSMutableArray new];
    _bottomSquares = [NSMutableArray new];
    
    for (UIView *squareView in self.view.subviews) {
        if (squareView.tag == 0) {
            [_topSquares addObject:squareView];
        } else {
            [_bottomSquares addObject:squareView];
        }
        squareView.layer.cornerRadius = 25;
    }
    
    [self startGame];
}

- (void)startGame
{
    _shotClock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickClock) userInfo:nil repeats:YES];
    _shotClockTimeLeft = 45;
    _score = 0;
    
    [_shotClock fire];
}

- (void)tickClock
{
    if (_shotClockTimeLeft == 0) {
        [_shotClock invalidate];
        [_timerLabel setText:@"Game Over"];
    } else {
        _shotClockTimeLeft --;
        [_timerLabel setText:[NSString stringWithFormat:@"%d seconds left", _shotClockTimeLeft]];
    }
}

- (void)placeStarOnRandomView:(UIButton *)starButton bottom:(BOOL)bottom
{
    if (bottom) {
        NSUInteger r = arc4random_uniform(_topSquares.count);
        UIView *newStarView = _topSquares[r];
        [newStarView addSubview:starButton];
    } else {
        NSUInteger r = arc4random_uniform(_bottomSquares.count);
        UIView *newStarView = _bottomSquares[r];
        [newStarView addSubview:starButton];
    }
    
}

- (IBAction)starWasTapped:(id)sender
{
    _score ++;
    [_scoreLabel setText:[NSString stringWithFormat:@"%d points", _score]];
    
    UIButton *starButton = sender;
    BOOL bottom = starButton.superview.tag; // tag 0 will be FALSE, tag 1 will be TRUE
    [starButton removeFromSuperview];
    [self placeStarOnRandomView:starButton bottom:bottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
