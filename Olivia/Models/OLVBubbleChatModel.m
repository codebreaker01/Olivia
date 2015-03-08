//
//  OLVBubbleChatModel.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVBubbleChatModel.h"

@implementation OLVBubbleChatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.messages = [NSMutableArray new];
        self.users = [NSMutableDictionary new];
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        JSQMessagesAvatarImage *olvImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"Olivia-60"]
                                                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"user-60"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ kIDOlivia : olvImage,
                          kIDUSer : userImage};
        
        self.users = @{ kIDOlivia : kNameOlivia,
                        kIDUSer : kNameUser};
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

@end
