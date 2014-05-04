//
//  SlidingMenuViewController.h
//  SlidingMenu
//
//  Created by Tim Searle on 18/03/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import "RUMSlidingMenuProtocol.h"
#import "RUMSlidingMenuCenterProtocol.h"

@interface RUMSlidingMenuViewController : UIViewController<RUMSlidingMenuProtocol>

/*! Create an instance of RUMSlidingViewController with a central viewController and two optional view controllers
 * to be revealed on the left and right.
 *\param rootViewController A UIViewController to be displayed in the centre of RUMSlidingMenuViewController. This controller must conform to
 * RUMSlidingMenuCenterProtocol. (Must not be nil)
 *\param leftViewController A UIViewController to be displayed on the left-hand side of the central controller. (Optional)
 *\param rightViewController A UIViewController to be displayed on the right-hand side of the central controller. (Optional)
 *\return A RUMSlidingViewController instance, configured with the supplied view controllers.
 */
- (instancetype)initWithRootViewController:(UIViewController<RUMSlidingMenuCenterProtocol> *)rootViewController
                        leftViewController:(UIViewController *)leftViewController
                       rightViewController:(UIViewController *)rightViewController;

@end
