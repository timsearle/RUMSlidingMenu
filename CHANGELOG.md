# RUMSlidingMenu CHANGELOG

## 1.1.0

* Introduced an `NSNotification` that broadcasts a `kSlidingMenuStateChangeNotification`, to inform the app that the menu is either opening or closing, using the following `NS_ENUM`:

		typedef NS_ENUM(NSInteger, RUMSlidingMenuState) {
    	RUMSlidingMenuStateOpening,
    	RUMSlidingMenuStateClosing
		};

## 1.0.0

Initial release.
