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

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
#error "UINavigationController (DAPowerfulCustomization) must be compiled under iOS 9 SDK at least"
#endif

NS_ASSUME_NONNULL_BEGIN
/**
 A category to expand UINavigationController
 
 1. When setLeftBarButtonItems: or setLeftBarButtonItem: on UINavigationItem, the default interactive pop gesture is avalible like normal, you do not need to do more.
 2. When using the properties of UINavigationItem below, you can easily custom the navigation bar and status bar appearance in different view controllers, the appearance transition when push or pop will be wonderful.
 3. When user click the default back button on navigation bar, you can handle the click event and you can prevent the pop event by returning NO.
 4. You can handle the interactive pop gesture recognizer event, returning no to prevent it began.
 
 Enjoy it.
 */
@interface UINavigationController (DAPowerfulCustomization)

@end

/**
 A category to expand UINavigationItem
 
 Apple recommends each UIViewController use it's navigationItem to decide navigationBar appearance, such as title, titleView and so on. Sometimes the properties of UINavigationItem are not enough, so I expand the UINavigationItem to realize more customization of UINavigationBar.
 
 You can use the properites below in your view controller, then the appearance of UINavigationBar in UINavigationController will auto update based on different UIViewController. I also do a little work to make status bar update alongside the view controller transition, you can use the three statusBar properties, or just use the methods of UIViewController which provided by Apple. Enjoy it.
 */
@interface UINavigationItem (DAPowerfulCustomization)

@property (nonatomic, assign) IBInspectable UIStatusBarStyle da_statusBarStyle;
@property (nonatomic, assign) IBInspectable UIStatusBarAnimation da_statusBarAnimation;
@property (nonatomic, assign) IBInspectable BOOL da_statusBarHidden;
@property (nonatomic, assign) IBInspectable UIBarStyle da_navigationBarStyle;
@property (nonatomic, assign) IBInspectable BOOL da_navigationBarShadowImageHidden;
@property (nonatomic, strong, nullable) IBInspectable UIColor *da_navigationBarTintColor;
@property (nonatomic, strong, nullable) IBInspectable UIColor *da_navigationBarBarTintColor;
@property (nonatomic, assign) IBInspectable BOOL da_navigationBarHidden;
@property (nonatomic, assign) IBInspectable CGFloat da_navigationBarBackgroundViewAlpha;
@property (nonatomic, copy, nullable) NSDictionary<NSString *,id> *da_navigationBarTitleTextAttributes;

@end

@protocol DANavigationControllerPopHandler <NSObject>
@optional
/**
 Override this method in UIViewController derived class to handle interactivePopGestureRecognizer

 @param interactivePopGestureRecognizer UINavigationController's interactivePopGestureRecognizer
 @return YES or NO, when return NO, then interactivePopGestureRecognizer will not begin
 */
- (BOOL)da_interactivePopGestureRecognizerShouldBegin:(nonnull __kindof UIGestureRecognizer *)interactivePopGestureRecognizer;
/**
 Override this method in UIViewController derived class to handle 'Back' button click
 */
- (BOOL)da_navigationControllerShouldPopOnBackButton;

@end

/**
 Some navigationItem updates setting using for DANavigationItemUpdatesConfiguration
 */
@interface DANavigationItemUpdate : NSObject
/**
 The UINavigationItem keyPath
 */
@property (nonatomic, copy, nonnull) NSString *navigationItemKeyPath;
/**
 From value
 */
@property (nonatomic, strong, nullable) id fromValue;
/**
 To value
 */
@property (nonatomic, strong, nonnull) id toValue;
/**
 Quickly create a update instance

 @param keyPath UINavigationItem keyPath
 @param fromValue fromValue
 @param toValue toValue
 @return a update instance
 */
+ (nullable instancetype)updateWithNavigationItemKeyPath:(nonnull NSString *)keyPath fromValue:(nullable id)fromValue toValue:(nullable id)toValue;

@end

/**
 If you want navigationItem update automatically, you need to create a configuration and set it to a UIViewController
 */
@interface DANavigationItemUpdatesConfiguration : NSObject
/**
 The scrollView we observe, when it scrolls we update navigationItem according it's contentOffset
 */
@property (nonatomic, strong) UIScrollView *observedScrollView;
/**
 The trigger offset when update begins. When scrollView contentOffset is greater than it, the update will change to toValue, otherwise fromeValue
 */
@property (nonatomic, assign) CGPoint triggerOffset;
/**
 Some keyPath update need to update at a appropriate percent. The default value is 0.5.
 */
@property (nonatomic, assign) CGFloat triggerPercent;
/**
 All updates you want navigationItem to update automatically.
 */
@property (nonatomic, copy, nonnull) NSArray<DANavigationItemUpdate *> *navigationItemUpdates;
/**
 If you want navigation item automatically update according the triggerOffset and triggerPercent, set it to YES. The default value is YES.
 */
@property (nonatomic, assign) BOOL automaticallyUpdateNavigationItemWhenScrollViewScrolls;
/**
 Quickly create an instance

 @param scrollView the scrollView we observed
 @param triggerOffset when the scrollView scrolls, it determines when to update
 @param navigationItemUpdates all you want the navigation item to update
 @return a configuration instance
 */
+ (nullable instancetype)configurationWithObservedScrollView:(nonnull UIScrollView *)scrollView triggerOffset:(CGPoint)triggerOffset navigationItemUpdates:(nonnull NSArray<DANavigationItemUpdate *> *)navigationItemUpdates;

@end
/**
 Make every UIViewController conforms to protocol <DANavigationControllerPopHandler>
 */
@interface UIViewController (DAPowerfulCustomization) <DANavigationControllerPopHandler>
/**
 You can use this property to update navigation item automatically, some details see DANavigationItemUpdatesConfiguration
 */
@property (nonatomic, strong, nullable) DANavigationItemUpdatesConfiguration *da_navigationItemUpdatesConfiguration;

@end

NS_ASSUME_NONNULL_END
