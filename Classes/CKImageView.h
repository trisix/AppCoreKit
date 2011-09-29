//
//  CKImageView.h
//  CloudKit
//
//  Created by Fred Brunel on 10-05-20.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKImageLoader.h"



/* COMMENT :
     In interactive mode, we replace the imageView by a UIButton to handle touchs.
     This has limitations :
       * the contentMode in the button does not respect the one we set for all states.
     We'll have to implements touchs and feedback drawing if we want to handle it correctly.
 */


@class CKImageView;


/** TODO
 */
@protocol CKImageViewDelegate

- (void)imageView:(CKImageView *)imageView didLoadImage:(UIImage *)image cached:(BOOL)cached;
- (void)imageView:(CKImageView *)imageView didFailLoadWithError:(NSError *)error;

@end

//

/** TODO
 */
typedef enum {
	CKImageViewStateNone,
	CKImageViewStateSpinner,
	CKImageViewStateDefaultImage,
	CKImageViewStateImage
}CKImageViewState;

/** TODO
 */
typedef enum{
	CKImageViewSpinnerStyleWhiteLarge = UIActivityIndicatorViewStyleWhiteLarge,
    CKImageViewSpinnerStyleWhite = UIActivityIndicatorViewStyleWhite,
    CKImageViewSpinnerStyleGray = UIActivityIndicatorViewStyleGray,
	CKImageViewSpinnerStyleNone
}CKImageViewSpinnerStyle;


/** TODO
 */
@interface CKImageView : UIView <CKImageLoaderDelegate> {
	//Image Management
	CKImageLoader *_imageLoader;
	NSURL *_imageURL;
	id<CKImageViewDelegate> _delegate;
	
	//Background View Management
	UIImage *_defaultImage;	
	UIView* _defaultImageView;
	UIActivityIndicatorView* _activityIndicator;
	CKImageViewSpinnerStyle _spinnerStyle;
	
	//View Management
	UIImageView* _imageView;
	BOOL _interactive;
	
	NSTimeInterval _fadeInDuration;
	CKImageViewState _currentState;
}

@property (nonatomic, retain, readwrite) NSURL *imageURL;
@property (nonatomic, retain, readwrite) UIImage *defaultImage;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, assign, readwrite) UIViewContentMode imageViewContentMode;
@property (nonatomic, assign, readwrite) id<CKImageViewDelegate> delegate;
@property (nonatomic, assign, readwrite) NSTimeInterval fadeInDuration;
@property (nonatomic, assign, readwrite) BOOL interactive;
@property (nonatomic, retain, readonly) UIButton *button;
@property (nonatomic, retain, readonly) UIView *defaultImageView;
@property (nonatomic, assign, readwrite) CKImageViewSpinnerStyle spinnerStyle;

- (void)loadImageWithContentOfURL:(NSURL *)url;
- (void)reload;
- (void)reset;
- (void)cancel;

@end

@interface CKImageView (CKBindings)

- (void)bindEvent:(UIControlEvents)controlEvents withBlock:(void (^)())block;
- (void)bindEvent:(UIControlEvents)controlEvents target:(id)target action:(SEL)selector;

@end
