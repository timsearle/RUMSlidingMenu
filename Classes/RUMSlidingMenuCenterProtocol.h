//
//  SlidingMenuRootViewControllerProtocol.h
//  SlidingMenu
//
//  Created by Tim Searle on 20/03/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import "RUMSlidingMenuProtocol.h"

@protocol RUMSlidingMenuCenterProtocol <NSObject>

/*! The object that acts as the delegate of the receiving RUMSlidingMenuViewController. 
 * The delegate must adopt the RUMSlidingMenuCenterProtocol protocol. The delegate is not retained.
 */
@property (nonatomic,weak) id<RUMSlidingMenuProtocol>delegate;

@end
