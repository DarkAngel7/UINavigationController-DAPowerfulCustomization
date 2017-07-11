# UINavigationController+DAPowerfulCustomization
A category to expand UINavigationController

 1. When setLeftBarButtonItems: or setLeftBarButtonItem: on UINavigationItem, the default interactive pop gesture is avalible like normal, you do not need to do more.

 2. When using the properties of UINavigationItem below, you can easily custom the navigation bar and status bar appearance in different view controllers, the appearance transition when push or pop will be wonderful.

 3. When user click the default back button on navigation bar, you can handle the click event and you can prevent the pop event by returning NO.

 4. You can handle the interactive pop gesture recognizer event, returning no to prevent it began.

 Enjoy it.

## Communication

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation
Use CocoaPods

```bash
pod 'UINavigationController+DAPowerfulCustomization'
```
## Requirements

 Minimum iOS Target  **iOS 9.0**.

## Architecture

- `UINavigationController+DAPowerfulCustomization.h`
- `UINavigationController+DAPowerfulCustomization.m`

## Usage

### Import

```objective-c
#import "UINavigationController+DAPowerfulCustomization.h"
```

### Use UINavigationItem+DAPowerfulCustomization

A category to expand UINavigationItem

Apple recommends each UIViewController use it's navigationItem to decide navigationBar appearance, such as title, titleView and so on. Sometimes the properties of UINavigationItem are not enough, so I expand the UINavigationItem to realize more customization of UINavigationBar.

You can use the properites below in your view controller, then the appearance of UINavigationBar in UINavigationController will auto update based on different UIViewController. I also do a little work to make status bar update alongside the view controller transition, you can use the three statusBar properties, or just use the methods of UIViewController which provided by Apple. Enjoy it.

```objective-c
self.navigationItem.da_statusBarStyle = UIStatusBarStyleLightContent;
self.navigationItem.da_statusBarHidden = NO;
self.navigationItem.da_statusBarAnimation = UIStatusBarAnimationFade;
self.navigationItem.da_navigationBarTintColor = [UIColor yellowColor];
self.navigationItem.da_navigationBarBarTintColor = [UIColor redColor];
self.navigationItem.da_navigationBarBackgroundViewAlpha = .5;
self.navigationItem.da_navigationBarTranslucent = YES;
self.navigationItem.da_navigationBarTitleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:25]};
self.navigationItem.da_navigationBarHidden = YES;
self.navigationItem.da_navigationBarStyle = UIBarStyleBlack;
```

### Use DANavigationControllerPopHandler

```objective-c
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
 Make every UIViewController conforms to protocol <DANavigationControllerPopHandler>
 */
@interface UIViewController (DAPowerfulCustomization) <DANavigationControllerPopHandler>
@end
```

What you need is to override DANavigationControllerPopHandler methods in your view controller. It's very easy.

## License

**UINavigationController+DAPowerfulCustomization** is released under the MIT license. See LICENSE for details.