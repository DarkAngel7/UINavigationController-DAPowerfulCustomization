// The MIT License (MIT)
//
// Copyright (c) 2017 DarkAngel ( https://github.com/darkangel7 )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "UINavigationController+DAPowerfulCustomization.h"
#import <objc/runtime.h>

/**
 Method swizzling function
 */
static inline void da_class_methodSwizzling(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 Replace some function to empty implementation
 */
static inline void da_class_removeMethod(Class class, SEL originalSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    class_replaceMethod(class, originalSelector, imp_implementationWithBlock(^{}), method_getTypeEncoding(originalMethod));
}


/**
 A private extension to expand UINavigationItem
 */
@interface UINavigationItem ()

@property (nonatomic, weak, readonly) UINavigationController *da_navigationController;
@property (nonatomic, weak, readonly) UINavigationBar *da_navigationBar;

@end

@implementation UINavigationItem (DAPowerfulCustomization)

#pragma mark - Setters

- (void)setDa_statusBarStyle:(UIStatusBarStyle)da_statusBarStyle
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    if (self.da_statusBarStyle == da_statusBarStyle) {
        return;
    }
    objc_setAssociatedObject(self, @selector(da_statusBarStyle), @(da_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UINavigationItem *item = navigationBar.topItem;
    // Here note the item is at the top of the stack or not
    if (self == item) {
        // Status bar update, we need to let navigationController update
        [self.da_navigationController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setDa_statusBarAnimation:(UIStatusBarAnimation)da_statusBarAnimation
{
    if (self.da_statusBarAnimation == da_statusBarAnimation) {
        return;
    }
    objc_setAssociatedObject(self, @selector(da_statusBarAnimation), @(da_statusBarAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        // Status bar update, we need to let navigationController update
        [self.da_navigationController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setDa_statusBarHidden:(BOOL)da_statusBarHidden
{
    if (self.da_statusBarHidden == da_statusBarHidden) {
        return;
    }
    objc_setAssociatedObject(self, @selector(da_statusBarHidden), @(da_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        // Status bar update, we need to let navigationController update
        [self.da_navigationController setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setDa_navigationBarStyle:(UIBarStyle)da_navigationBarStyle
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if (self.da_navigationBarStyle == da_navigationBarStyle) {
            return;
        }
        // Update navigationBar directly
        self.da_navigationBar.barStyle = da_navigationBarStyle;
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarStyle), @(da_navigationBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarTranslucent:(BOOL)da_navigationBarTranslucent
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if (self.isDa_navigationBarTranslucent == da_navigationBarTranslucent) {
            return;
        }
        self.da_navigationBar.translucent = da_navigationBarTranslucent;
    }
    objc_setAssociatedObject(self, @selector(isDa_navigationBarTranslucent), @(da_navigationBarTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarTintColor:(UIColor *)da_navigationBarTintColor
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if ([self.da_navigationBarTintColor isEqual:da_navigationBarTintColor]) {
            return;
        }
        navigationBar.tintColor = da_navigationBarTintColor;
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarTintColor), da_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarBarTintColor:(UIColor *)da_navigationBarBarTintColor
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if ([self.da_navigationBarBarTintColor isEqual:da_navigationBarBarTintColor]) {
            return;
        }
        navigationBar.barTintColor = da_navigationBarBarTintColor;
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarBarTintColor), da_navigationBarBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarHidden:(BOOL)da_navigationBarHidden
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    UINavigationController *nvc = self.da_navigationController;
    if (self == item && nvc) {
        if (self.da_navigationBarHidden == da_navigationBarHidden) {
            return;
        }
        // Do not use 'navigationBar.hidden = da_navigationBarHidden', we still let navigationController do that
        [nvc setNavigationBarHidden:da_navigationBarHidden animated:YES];
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarHidden), @(da_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarBackgroundViewAlpha:(CGFloat)da_navigationBarBackgroundViewAlpha
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if (self.da_navigationBarBackgroundViewAlpha == da_navigationBarBackgroundViewAlpha) {
            return;
        }
        // First we use KVC to get the UIBarBackground
        UIView *backgroundView = [navigationBar valueForKey:@"backgroundView"];
        // When 'setBackgroundImage:forBarMetrics:' a custom background image, we need to change the alpha of the backgroundView
        if ([navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] && [UIDevice currentDevice].systemVersion.floatValue < 11) {
            backgroundView.alpha = da_navigationBarBackgroundViewAlpha;
            [backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 1;
            }];
        } else {
            // If there's no custom background image, we change the alpha property of it's all subviews
            [backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = da_navigationBarBackgroundViewAlpha;
            }];
            backgroundView.alpha = 1;
        }
        
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarBackgroundViewAlpha), @(da_navigationBarBackgroundViewAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDa_navigationBarTitleTextAttributes:(NSDictionary<NSString *,id> *)da_navigationBarTitleTextAttributes
{
    UINavigationBar *navigationBar = self.da_navigationBar;
    UINavigationItem *item = navigationBar.topItem;
    if (self == item) {
        if ([self.da_navigationBarTitleTextAttributes isEqual:da_navigationBarTitleTextAttributes]) {
            return;
        }
        self.da_navigationBar.titleTextAttributes = da_navigationBarTitleTextAttributes;
    }
    objc_setAssociatedObject(self, @selector(da_navigationBarTitleTextAttributes), da_navigationBarTitleTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters

- (UIStatusBarStyle)da_statusBarStyle
{
    NSNumber *style = objc_getAssociatedObject(self, _cmd);
    return style ? style.integerValue : UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)da_statusBarAnimation
{
    NSNumber *animation = objc_getAssociatedObject(self, _cmd);
    return animation ? animation.integerValue : UIStatusBarAnimationFade;
}

- (BOOL)da_statusBarHidden
{
    NSNumber *isHidden = objc_getAssociatedObject(self, _cmd);
    return isHidden ? isHidden.boolValue : NO;
}

- (UIBarStyle)da_navigationBarStyle
{
    NSNumber *style = objc_getAssociatedObject(self, _cmd);
    return style ? style.integerValue : [UINavigationBar appearance].barStyle;
}

- (BOOL)isDa_navigationBarTranslucent
{
    NSNumber *isTranslucent = objc_getAssociatedObject(self, _cmd);
    return isTranslucent ? isTranslucent.boolValue : YES;
}

- (UIColor *)da_navigationBarTintColor
{
    return objc_getAssociatedObject(self, _cmd) ? : [UINavigationBar appearance].tintColor;
}

- (UIColor *)da_navigationBarBarTintColor
{
    return objc_getAssociatedObject(self, _cmd) ? : [UINavigationBar appearance].barTintColor;
}

- (BOOL)da_navigationBarHidden
{
    NSNumber *hidden = objc_getAssociatedObject(self, _cmd);
    return hidden ? hidden.boolValue : NO;
}

- (CGFloat)da_navigationBarBackgroundViewAlpha
{
    NSNumber *alpha = objc_getAssociatedObject(self, _cmd);
    return alpha ? alpha.doubleValue : 1;
}

- (NSDictionary<NSString *,id> *)da_navigationBarTitleTextAttributes
{
    return objc_getAssociatedObject(self, _cmd) ? : [UINavigationBar appearance].titleTextAttributes;
}

#pragma mark - Private Methods

/**
 Usually a UINavigationBar is managed by UINavigationControll, and it's delegate is UINavigationController, so we use delegate to get navigationController
 */
- (nullable UINavigationController *)da_navigationController
{
    UINavigationController *nvc;
    if (self.da_navigationBar && [self.da_navigationBar.delegate isKindOfClass:[UINavigationController class]]) {
        nvc = (UINavigationController *)self.da_navigationBar.delegate;
    }
    return nvc;
}

/**
 Use KVC to get the navigationBar
 */
- (UINavigationBar *)da_navigationBar
{
    return [self valueForKey:@"_navigationBar"];
}

@end

@interface DANavigationControllerPopGestureDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation DANavigationControllerPopGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    // If there is only one rootViewController, no need to receive touch
    if (self.navigationController.topViewController == self.navigationController.viewControllers.firstObject || self.navigationController.viewControllers.count < 2) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Here let every viewController have the opportunity to decide whether can begin interactive gesture recognizer
    if ([self.navigationController.topViewController respondsToSelector:@selector(da_interactivePopGestureRecognizerShouldBegin:)]) {
        return [self.navigationController.topViewController da_interactivePopGestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

@end

@interface UINavigationController ()

@property (nonatomic, strong) UIViewController *da_transitionViewController;

@end

@implementation UINavigationController (DAPowerfulCustomization)

#pragma mark - Hook Methods

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        da_class_methodSwizzling([self class], @selector(viewDidLoad), @selector(da_viewDidLoad));
        da_class_methodSwizzling([self class], @selector(pushViewController:animated:), @selector(da_pushViewController:animated:));
        da_class_methodSwizzling([self class], @selector(setViewControllers:animated:), @selector(da_setViewControllers:animated:));
        da_class_methodSwizzling([self class], @selector(popViewControllerAnimated:), @selector(da_popViewControllerAnimated:));
        da_class_methodSwizzling([self class], @selector(popToViewController:animated:), @selector(da_popToViewController:animated:));
        da_class_methodSwizzling([self class], @selector(popToRootViewControllerAnimated:), @selector(da_popToRootViewControllerAnimated:));
        da_class_methodSwizzling([self class], @selector(navigationBar:shouldPopItem:), @selector(da_navigationBar:shouldPopItem:));
        da_class_removeMethod(NSClassFromString([[@"_" stringByAppendingString:@"UIBar"] stringByAppendingString:@"Background"]), NSSelectorFromString([@"setShadow" stringByAppendingString:@"Alpha:"]));
    });
}

- (void)da_viewDidLoad
{
    // Call the default implementation
    [self da_viewDidLoad];
    // Update the bar appearance
    dispatch_async(dispatch_get_main_queue(), ^{
        [self da_updateNavigationBarAndStatusBarAppearance];
    });
    // Change the delegate of interactivePopGestureRecognizer, we manage it ourselves
    self.interactivePopGestureRecognizer.delegate = [self da_popGestureDelegate];
}

- (void)da_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self da_pushViewController:viewController animated:animated];
    // Fix bugs of some system UINavigationController subclasses
    if ([viewController isKindOfClass:NSClassFromString([@"PUUI" stringByAppendingString:@"ImageViewController"])]) {
        return;
    }
    [self da_updateNavigationBarAndStatusBarAppearance];
}

- (void)da_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [self da_setViewControllers:viewControllers animated:animated];
    [self da_updateNavigationBarAndStatusBarAppearance];
}

- (UIViewController *)da_popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [self da_popViewControllerAnimated:animated];
    [self da_updateNavigationBarAndStatusBarAppearance];
    return vc;
}

- (NSArray<UIViewController *> *)da_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray <UIViewController *> *vcs = [self da_popToViewController:viewController animated:animated];
    [self da_updateNavigationBarAndStatusBarAppearance];
    return vcs;
}

- (NSArray<UIViewController *> *)da_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray <UIViewController *> *vcs = [self da_popToRootViewControllerAnimated:animated];
    [self da_updateNavigationBarAndStatusBarAppearance];
    return vcs;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *vc = self.da_transitionViewController ? : self.topViewController;
    NSNumber *style = objc_getAssociatedObject(vc.navigationItem, @selector(da_statusBarStyle));
    return style ? style.integerValue : vc.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    UIViewController *vc = self.da_transitionViewController ? : self.topViewController;
    NSNumber *hidden = objc_getAssociatedObject(vc.navigationItem, @selector(da_statusBarHidden));
    return hidden ? hidden.boolValue : vc.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIViewController *vc = self.da_transitionViewController ? : self.topViewController;
    NSNumber *animation = objc_getAssociatedObject(vc.navigationItem, @selector(da_statusBarAnimation));
    return animation ? animation.integerValue : vc.preferredStatusBarUpdateAnimation;
}

- (BOOL)da_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if (self.viewControllers.count < navigationBar.items.count) {
        return YES;
    }
    UIViewController *vc = self.topViewController;
    BOOL shouldPop = YES;
    if([vc respondsToSelector:@selector(da_navigationControllerShouldPopOnBackButton)]) {
        shouldPop = [vc da_navigationControllerShouldPopOnBackButton];
    }
    if (shouldPop) {
        return [self da_navigationBar:navigationBar shouldPopItem:item];
    } else {
        [UIView animateWithDuration:.13 animations:^{
            UIView *backIndicatorView = [self.navigationBar valueForKey:@"backIndicatorView"];
            backIndicatorView.alpha = 1;
        }];
        return NO;
    }
}

#pragma mark - Private Methods
/**
 Update the status bar and navigation bar appearance.
 When in transition, updates will animate alongside the transition
 */
- (void)da_updateNavigationBarAndStatusBarAppearance
{
    // Get current system version to fix some bugs of different iOS versions
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    
    // Get current transitionCoordinator
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    
    // If there is no transitionCoordinator, we update directly
    if (!tc) {
        // Update navigation bar based on the navigationItem of topViewController
        UIViewController *vc = self.topViewController;
        [vc.view layoutIfNeeded];
        [self da_updateNavigationBarWithNavigationItem:vc.navigationItem];
        [self da_updateStatusBarWithViewController:vc];
    } else {
        UIViewController *fromVC = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
        [toVC.view layoutIfNeeded];
        
        // When navigationBar doesn't need to update hidden property, use fade transition animation
        if (toVC.navigationItem.da_navigationBarHidden == self.navigationBarHidden && !self.navigationBarHidden) {
            UIView *backgroundView = [self.navigationBar valueForKey:@"backgroundView"];
            
            // A little trick, when setBackgroundImage:forBarMetrics: and navigationBar has a custom background image on iOS version 11 or more, the background image transition is bad, so just do a little trick.
            dispatch_block_t completion;
            if (systemVersion >= 11 && fromVC.navigationItem.da_navigationBarBackgroundViewAlpha != toVC.navigationItem.da_navigationBarBackgroundViewAlpha) {
                UIImageView *backgroundImgView = [backgroundView valueForKey:@"backgroundImageView"];
                backgroundImgView.hidden = YES;
                UIImageView *fakeBackgroundImgView = [self da_fakeBackgroundImageView];
                fakeBackgroundImgView.image = backgroundImgView.image;
                [backgroundView insertSubview:fakeBackgroundImgView atIndex:0];
                fakeBackgroundImgView.frame = backgroundImgView.frame;
                fakeBackgroundImgView.alpha = backgroundImgView.alpha;
                backgroundImgView.alpha = toVC.navigationItem.da_navigationBarBackgroundViewAlpha;
                completion = ^{
                    // Remove the fake backgroundImgView and reset original backgroundImageView
                    backgroundImgView.hidden = NO;
                    [fakeBackgroundImgView removeFromSuperview];
                };
            }
            
            // Some updates to fix bugs
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:tc.transitionDuration * (1 - tc.percentComplete)];
            [UIView setAnimationCurve:tc.completionCurve];
            [UIView setAnimationBeginsFromCurrentState:YES];
            // Animation
            if (systemVersion >= 10) {
                self.navigationBar.barTintColor = toVC.navigationItem.da_navigationBarBarTintColor;
                self.navigationBar.titleTextAttributes = toVC.navigationItem.da_navigationBarTitleTextAttributes;
            }
            if (systemVersion >= 11) {
                // Fix background alpha transition bug
                if (!tc.isInteractive) {
                    [backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.alpha = toVC.navigationItem.da_navigationBarBackgroundViewAlpha;
                    }];
                }
            } else {
                // Fix feign death bug below iOS 11
                if (tc.isInteractive) {
                    [self da_updateStatusBarWithViewController:toVC];
                }
            }
            [UIView commitAnimations];
            
            // NavigationBar Appearance Updates animate alongside transition
            [tc animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                [self da_updateNavigationBarWithNavigationItem:toVC.navigationItem];
            } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if (completion) {
                    completion();
                }
            }];
        } else {
            // Fix bugs below iOS 11
            if (systemVersion < 11 && tc.isInteractive) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:tc.transitionDuration * (1 - tc.percentComplete)];
                [UIView setAnimationCurve:tc.completionCurve];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [self da_updateStatusBarWithViewController:toVC];
                [UIView commitAnimations];
            }
            // If both hidden = YES, then do nothing. One hidden = YES, one hidden = NO, then do a little work
            if (self.navigationBarHidden != toVC.navigationItem.da_navigationBarHidden) {
                if (toVC.navigationItem.da_navigationBarHidden) {
                    [self setNavigationBarHidden:YES animated:tc.isAnimated];
                } else {
                    [self da_updateNavigationBarWithNavigationItem:toVC.navigationItem];
                }
            }
        }
        // Animate status bar appearance updates alongside transition
        [tc animateAlongsideTransitionInView:[[UIApplication sharedApplication] valueForKey:@"statusBar"] animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self da_updateStatusBarWithViewController:toVC];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            // Update bar appearance again
            UIViewController *vc = context.isCancelled ? fromVC : toVC;
            [self da_updateNavigationBarWithNavigationItem:vc.navigationItem];
            [self da_updateStatusBarWithViewController:vc];
        }];
        // Below iOS 11, when interaction ends, the navigationBar appearance update will not be cancelled, we need to cancel it ourselves.
        if (systemVersion < 11) {
            void (^cancel)(id) = ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if (context.isCancelled) {
                    [self da_updateStatusBarWithViewController:fromVC];
                    [self da_updateNavigationBarWithNavigationItem:fromVC.navigationItem];
                }
            };
#if __IPHONE_OS_VERSION_MIN_ALLOWED >= 100000
            [tc notifyWhenInteractionChangesUsingBlock:cancel];
#else
            if ([tc respondsToSelector:@selector(notifyWhenInteractionChangesUsingBlock:)]) {
                [tc notifyWhenInteractionChangesUsingBlock:cancel];
            } else {
                [tc notifyWhenInteractionEndsUsingBlock:cancel];
            }
#endif
        }
    }
}

/**
 Update navigationBar Appearance with the navigationItem
 This method may run in a block alongside the transition
 
 @param navigationItem a navigationItem to control navigationBar appearance
 */
- (void)da_updateNavigationBarWithNavigationItem:(UINavigationItem *)navigationItem
{
    // Just update
    self.navigationBar.barStyle = navigationItem.da_navigationBarStyle;
    self.navigationBar.translucent = navigationItem.isDa_navigationBarTranslucent;
    self.navigationBar.tintColor = navigationItem.da_navigationBarTintColor;
    self.navigationBar.barTintColor = navigationItem.da_navigationBarBarTintColor;
    [self setNavigationBarHidden:navigationItem.da_navigationBarHidden animated:self.transitionCoordinator.isAnimated];
    UIView *backgroundView = [self.navigationBar valueForKey:@"backgroundView"];
    if ([self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] && [UIDevice currentDevice].systemVersion.floatValue < 11) {
        backgroundView.alpha = navigationItem.da_navigationBarBackgroundViewAlpha;
        if (!self.transitionCoordinator.isInteractive) {
            [backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 1;
            }];
        }
    } else {
        dispatch_block_t backgroundViewUpdateHandler = ^{
            [backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = navigationItem.da_navigationBarBackgroundViewAlpha;
            }];
            backgroundView.alpha = 1;
        };
        backgroundViewUpdateHandler();
        // Fix bugs on iOS 11 when interaction ends
        if (!self.transitionCoordinator.isInteractive && [UIDevice currentDevice].systemVersion.floatValue >= 11) {
            dispatch_async(dispatch_get_main_queue(), backgroundViewUpdateHandler);
        }
    }
    self.navigationBar.titleTextAttributes = navigationItem.da_navigationBarTitleTextAttributes;
}

/**
 Update status bar appearance
 */
- (void)da_updateStatusBarWithViewController:(UIViewController *)viewController
{
    self.da_transitionViewController = viewController;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Setters and Getters

- (void)setDa_transitionViewController:(UIViewController *)da_transitionViewController
{
    objc_setAssociatedObject(self, @selector(da_transitionViewController), da_transitionViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)da_transitionViewController
{
    return objc_getAssociatedObject(self, _cmd) ? : self.topViewController;
}

- (DANavigationControllerPopGestureDelegate *)da_popGestureDelegate
{
    DANavigationControllerPopGestureDelegate *popGestureDelegate = objc_getAssociatedObject(self, _cmd);
    if (!popGestureDelegate) {
        popGestureDelegate = [[DANavigationControllerPopGestureDelegate alloc] init];
        popGestureDelegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, popGestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return popGestureDelegate;
}

- (UIImageView *)da_fakeBackgroundImageView
{
    UIImageView *fakeBackgroundImgView = objc_getAssociatedObject(self, _cmd);
    if (!fakeBackgroundImgView) {
        fakeBackgroundImgView = [[UIImageView alloc] init];
        objc_setAssociatedObject(self, _cmd, fakeBackgroundImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return fakeBackgroundImgView;
}

@end
