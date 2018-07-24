#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MBFadeSegue.h"
#import "MBGateCloseInsideSegue.h"
#import "MBGateCloseOutsideSegue.h"
#import "MBGateOpenInsideSegue.h"
#import "MBGateOpenOutsideSegue.h"
#import "MBSegue.h"
#import "MBShadowSplitCloseSegue.h"
#import "MBShadowSplitOpenSegue.h"
#import "MBSimpleSplitCloseSegue.h"
#import "MBSimpleSplitOpenSegue.h"

FOUNDATION_EXPORT double MBSegueCollectionVersionNumber;
FOUNDATION_EXPORT const unsigned char MBSegueCollectionVersionString[];

