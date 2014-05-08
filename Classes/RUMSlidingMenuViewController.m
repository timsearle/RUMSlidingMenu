//
//  SlidingMenuViewController.m
//  SlidingMenu
//
//  Created by Tim Searle on 18/03/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import "RUMSlidingMenuViewController.h"
#import "RUMSlidingMenuProtocol.h"

@interface RUMSlidingMenuViewController ()<UIGestureRecognizerDelegate,RUMSlidingMenuProtocol>

@property (nonatomic,strong) UIViewController<RUMSlidingMenuCenterProtocol> *rootViewController;
@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic,strong) UIViewController *rightViewController;
@property (nonatomic,strong) UIView *invisibleTapView;

@property (nonatomic,assign) BOOL leftViewVisible;
@property (nonatomic,assign) BOOL rightViewVisible;

- (UIView *)leftView;
- (UIView *)rightView;
- (void)dragMenu:(UIPanGestureRecognizer *)recognizer;

@end

static const CGFloat kMenuPadding = 150.0f;
static const CGFloat kAnimationDuration = 0.9f;
static const CGFloat kAnimationSpringDamping = 0.8f;
static const CGFloat kAnimationInitialVelocity = 10.0f;

@implementation RUMSlidingMenuViewController

#pragma mark - Constants

NSString *const kSlidingMenuStateChangeNotification = @"slidingMenuStateHasChanged";

#pragma mark - SlidingMenuViewController

- (instancetype)initWithRootViewController:(UIViewController<RUMSlidingMenuCenterProtocol> *)rootViewController
                        leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController
{
    self = [super init];
    
    if (self) {
        NSAssert(rootViewController != nil, @"rootViewController must not be nil");
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup gesture recognizer
    UIPanGestureRecognizer *menuDragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMenu:)];
    menuDragRecognizer.delegate = self;
    [self.rootViewController.view addGestureRecognizer:menuDragRecognizer];
    

    // Setup rootViewController as a child
    self.rootViewController.view.frame = [[[[UIApplication sharedApplication] delegate] window] frame];
    [self.view addSubview:self.rootViewController.view];
    [self addChildViewController:self.rootViewController];
    [self.rootViewController didMoveToParentViewController:self];
    self.rootViewController.delegate = self;
}

- (void)dragMenu:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"Dragging");
}

#pragma mark - SlidingMenuViewController (Private)

- (UIView *)leftView
{
    if (![self.rootViewController.childViewControllers containsObject:self.leftViewController]) {
        [self.view addSubview:self.leftViewController.view];
        [self addChildViewController:self.leftViewController];
        [self.leftViewController didMoveToParentViewController:self];
    }
    
    return self.leftViewController.view;
}

- (UIView *)rightView
{
    if (![self.rootViewController.childViewControllers containsObject:self.rightViewController]) {
        [self.view addSubview:self.rightViewController.view];
        [self addChildViewController:self.rightViewController];
        [self.rightViewController didMoveToParentViewController:self];
    }
    
    return self.rightViewController.view;
}

- (UIView *)invisibleTapView
{
    if (!_invisibleTapView) {
        _invisibleTapView = [[UIView alloc] initWithFrame:self.rootViewController.view.frame];
        _invisibleTapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *dismissMenuTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(resetMenu)];
        [_invisibleTapView addGestureRecognizer:dismissMenuTapGestureRecognizer];
    }
    
    return _invisibleTapView;
}

#pragma mark - SlidingMenuProtocol

- (void)toggleRightMenu
{
    NSAssert(self.rightViewController != nil, @"rightViewController must not be nil if attempting to reveal");
    
    RUMSlidingMenuState state = self.rightViewVisible ? RUMSlidingMenuStateClosing : RUMSlidingMenuStateOpening;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlidingMenuStateChangeNotification object:@(state)];
    
    if (self.rightViewVisible) {
        [self resetMenu];
    } else {
        [self.rootViewController.view addSubview:self.invisibleTapView];
        [self.view sendSubviewToBack:[self rightView]];
        
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0f
             usingSpringWithDamping:kAnimationSpringDamping
              initialSpringVelocity:kAnimationInitialVelocity
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGRect currentFrame = self.rootViewController.view.frame;
                             self.rootViewController.view.frame = CGRectOffset(currentFrame,
                                                                               (-self.view.frame.size.width + kMenuPadding),
                                                                               0.0f);
        } completion:^(BOOL finished) {
            if (finished) {
                self.rightViewVisible = YES;
            }
        }];
    }
}

- (void)toggleLeftMenu
{
    NSAssert(self.leftViewController != nil, @"leftViewController must not be nil if attempting to reveal");
    
    RUMSlidingMenuState state = self.leftViewVisible ? RUMSlidingMenuStateClosing : RUMSlidingMenuStateOpening;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlidingMenuStateChangeNotification object:@(state)];
    
    if (self.leftViewVisible) {
        [self resetMenu];
    } else {
        [self.rootViewController.view addSubview:self.invisibleTapView];
        [self.view sendSubviewToBack:[self leftView]];
        
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.0f
             usingSpringWithDamping:kAnimationSpringDamping
              initialSpringVelocity:kAnimationInitialVelocity
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGRect currentFrame = self.rootViewController.view.frame;
                             self.rootViewController.view.frame = CGRectOffset(currentFrame,(self.view.frame.size.width - kMenuPadding),
                                                                             0.0f);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                self.leftViewVisible = YES;
                             }
                         }];
    }
}

- (void)resetMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlidingMenuStateChangeNotification object:@(RUMSlidingMenuStateClosing)];
    
    [self.invisibleTapView removeFromSuperview];
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0f
         usingSpringWithDamping:kAnimationSpringDamping
          initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                                CGRect currentFrame = self.rootViewController.view.frame;
                                self.rootViewController.view.frame = CGRectMake(0.0f, 0.0f, currentFrame.size.width, currentFrame.size.height);
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    self.leftViewVisible = NO;
                                    self.rightViewVisible = NO;
                                }
    }];
}

@end
