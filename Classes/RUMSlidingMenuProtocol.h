//
//  SlidingMenuProtocol.h
//  SlidingMenu
//
//  Created by Tim Searle on 18/03/2014.
//  Copyright (c) 2014 . All rights reserved.
//

@protocol RUMSlidingMenuProtocol <NSObject>

@optional

/*! Toggle between revealing and hiding the left hand menu of the RUMSlidingMenuViewController. (Optional)
 */
- (void)toggleLeftMenu;

/*! Toggle between revealing and hiding the right hand menu of the RUMSlidingMenuViewController. (Optional)
 */
- (void)toggleRightMenu;

@required

/*! Return menu back to default position in centre of screen (Required)
 */
- (void)resetMenu;

@end