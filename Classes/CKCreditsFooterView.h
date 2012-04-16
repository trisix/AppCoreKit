//
//  CKCreditsFooterView.h
//  CloudKit
//
//  Created by Olivier Collet on 10-09-08.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	CKCreditsViewStyleLight = 0,
	CKCreditsViewStyleDark
} CKCreditsViewStyle;

/** TODO
 */
@interface CKCreditsFooterView : UIView {
}

+ (id)creditsViewWithStyle:(CKCreditsViewStyle)style;

@end