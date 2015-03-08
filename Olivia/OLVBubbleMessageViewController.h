//
//  OLVBubbleMessageViewController.h
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "JSQMessages.h"

@class OLVBubbleMessageViewController;

@protocol OLVBubbleMessageViewControllerDelegate <NSObject>

- (void)didDismissViewController:(OLVBubbleMessageViewController *)vc;

@end


@interface OLVBubbleMessageViewController : JSQMessagesViewController

@property (weak, nonatomic) id<OLVBubbleMessageViewControllerDelegate> delegateModal;

- (void)addMessage:(NSString *)message byUserID:(NSString *)userID;

@end
