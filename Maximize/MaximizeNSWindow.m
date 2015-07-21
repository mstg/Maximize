//
//  MaximizeNSWindow.m
//  Maximize
//
//  Created by Mustafa Gezen on 21.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

@import Opee;

@interface NSWindow (Maximizer)
- (void)setFrame:(struct CGRect)arg1 display:(BOOL)arg2 animate:(BOOL)arg3;
- (struct CGRect)_tileFrameForFullScreen;
- (void)_saveUserFrame;
@end

BOOL _isMaximized = NO;
BOOL _willMaximize = NO;
struct CGRect _cachedFrame;

ZKSwizzleInterface(_Maximize_NSWindow, NSWindow, NSResponder);
@implementation _Maximize_NSWindow

- (void)_setFrameAfterMove:(struct CGRect)arg1 {
	ZKOrig(void, arg1);
	if (!_willMaximize) {
		_cachedFrame = arg1;
		_isMaximized = NO;
	}
}

- (void)setFrame:(struct CGRect)arg1 display:(BOOL)arg2 animate:(BOOL)arg3 {
	ZKOrig(void, arg1, arg2, arg3);
	if (!_willMaximize) {
		_cachedFrame = arg1;
		_isMaximized = NO;
	}
	
}

- (void)_resizeSetFrame:(struct CGRect)arg1 withEvent:(id)arg2 shouldSnapWidth:(BOOL)arg3 shouldSnapHeight:(BOOL)arg4 {
	ZKOrig(void, arg1, arg2, arg3, arg4);
	if (!_willMaximize) {
		_cachedFrame = arg1;
		_isMaximized = NO;
	}
}

- (void)enterFullScreenMode:(id)arg1 {
	NSWindow *this = (NSWindow*)self;
	
	if (!_isMaximized) {
		_isMaximized = YES;
		_willMaximize = YES;
		[this setFrame:[this _tileFrameForFullScreen] display:true animate:true];
		[this _saveUserFrame];
		_willMaximize = NO;
	} else {
		[this setFrame:_cachedFrame display:true animate:true];
		[this _saveUserFrame];
		_isMaximized = NO;
	}
}

- (BOOL)_zoomButtonIsFullScreenButton {
	return YES;
}
@end