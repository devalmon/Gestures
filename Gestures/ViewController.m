//
//  ViewController.m
//  Gestures
//
//  Created by Alexey Baryshnikov on 02.06.2020.
//  Copyright © 2020 Alexey Baryshnikov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak)UIView *testView;
@property (nonatomic, assign)CGFloat testViewScale;
@property (nonatomic, assign)CGFloat testViewRotate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50, CGRectGetMidY(self.view.bounds) - 50, 100, 100)];
    view.layer.cornerRadius = 12;
    view.backgroundColor = [UIColor systemPinkColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:view];
    
    self.testView = view;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    UISwipeGestureRecognizer *verticalSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleVerticalSwipe:)];
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;

    UISwipeGestureRecognizer *horizontalSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleHorizontalSwipe:)];
    horizontalSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleGesture.numberOfTapsRequired = 2;
    [tapGesture requireGestureRecognizerToFail:doubleGesture];
    
    UITapGestureRecognizer *doubleTapDoubleTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapDoubleTouch:)];
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    doubleTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    
    pinchGesture.delegate = self;
    rotationGesture.delegate = self;
    verticalSwipeGesture.delegate = self;
    horizontalSwipeGesture.delegate = self;
    
    
    [self.view addGestureRecognizer:tapGesture];
    [self.view addGestureRecognizer:doubleGesture];
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
    [self.view addGestureRecognizer:verticalSwipeGesture];
    [self.view addGestureRecognizer:horizontalSwipeGesture];
    [self.view addGestureRecognizer:panGesture];
    [self.view addGestureRecognizer:pinchGesture];
    [self.view addGestureRecognizer:rotationGesture];
    
}

#pragma mark - Methods -

- (UIColor *)randomColor {
    CGFloat r = (float)(arc4random() % 256) / 255;
    CGFloat g = (float)(arc4random() % 256) / 255;
    CGFloat b = (float)(arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

#pragma mark ***Gestures***
- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"handleTap at %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    self.testView.backgroundColor = [self randomColor];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTabGesture {
    NSLog(@"handleDoubleTap at %@", NSStringFromCGPoint([doubleTabGesture locationInView:self.view]));
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);

    [UIView animateWithDuration:0.3 animations:^{
        self.testView.transform = newTransform;
    }];
    
    self.testViewScale = 1.2f;
}
- (void)handleDoubleTapDoubleTouch:(UITapGestureRecognizer *)doubleTapDoubleTouchGesture {
    NSLog(@"handleDoubleTapDoubleTouch at %@", NSStringFromCGPoint([doubleTapDoubleTouchGesture locationInView:self.view]));
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.8f, 0.8f);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.testView.transform = newTransform;
    }];
    
    self.testViewScale = 0.8f;
}
- (void)handleVerticalSwipe:(UISwipeGestureRecognizer *)swipeGesture {
    NSLog(@"handleVerticalSwipe");
}
- (void)handleHorizontalSwipe:(UISwipeGestureRecognizer *)swipeGesture {
    NSLog(@"handleHorizontalSwipe");
}
- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"handlePan");
    self.testView.center = [panGesture locationInView:self.view];
}
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"pinch scale: %1.3f", pinchGesture.scale);
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewScale = 1.f;
    }
    
    CGFloat newScale = 1 + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testView.transform = newTransform;
    self.testViewScale = pinchGesture.scale;
    
}
- (void)handleRotate:(UIRotationGestureRecognizer *)rotateGesture {
    NSLog(@"rotated at %1.3f", rotateGesture.rotation);
    if (rotateGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotate = 0;
    }
    
    CGFloat newRotation = rotateGesture.rotation - self.testViewRotate;
    
    CGAffineTransform currentTransfomr = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransfomr, newRotation);
    self.testView.transform = newTransform;
    self.testViewRotate = rotateGesture.rotation;
}
#pragma mark - UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma mark ***Touches***
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint mainPoint = [touch locationInView:self.view];
    
    NSLog(@"touchesBegan at %@", NSStringFromCGPoint(mainPoint));
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint mainPoint = [touch locationInView:self.view];
    NSLog(@"touchesMoved at %@", NSStringFromCGPoint(mainPoint));
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    //TODO: complite touchesEnded method
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    //TODO: complite cancel method
}
*/
@end


