//
//  OLVBubbleMessageViewController.m
//  Olivia
//
//  Created by Deepu Mukundan on 3/7/15.
//  Copyright (c) 2015 Jaikumar Bhambhwani. All rights reserved.
//

#import "OLVBubbleMessageViewController.h"
#import "OLVBubbleChatModel.h"
#import <ApiAI/ApiAI.h>
#import <ApiAI/AIVoiceRequest.h>
#import "ApiAIHelper.h"

@interface OLVBubbleMessageViewController ()
@property (strong, nonatomic) OLVBubbleChatModel *model;
@property (nonatomic, strong) ApiAI *apiAI;
@property (nonatomic, strong) AIVoiceRequest *currentVoiceRequest;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *micButton;
@property (nonatomic) BOOL isListening;
@property (nonatomic) NSInteger buttonSize;
@end

@implementation OLVBubbleMessageViewController

#pragma mark - View lifecycle
/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Olivia";
    self.buttonSize = 75;
    /**
     *  You MUST set your senderId and display name
     */
    self.senderId = kIDUSer;
    self.senderDisplayName = kNameUser;

    /**
     *  Load up our fake data for the demo
     */
    self.model = [[OLVBubbleChatModel alloc] init];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    UIButton *askButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    askButton.tintColor = [UIColor redColor];
    [askButton setTitle:@"Ask Olivia" forState:UIControlStateNormal];
    [askButton sizeToFit];
    self.inputToolbar.contentView.rightBarButtonItem = askButton;
    
    self.micButton = [[UIButton alloc] init];
    [self.micButton setImage:[UIImage imageNamed:@"MicBlack-Small-40"] forState:UIControlStateNormal];
    [self.micButton addTarget:self action:@selector(toggleListening) forControlEvents:UIControlEventTouchUpInside];
    self.inputToolbar.contentView.leftBarButtonItem = self.micButton;

    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.inputToolbar.contentView addSubview:self.activity];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(22, 0, 0, 0);
    
    self.apiAI = [ApiAI sharedApiAI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
    [self addMessage:@"Hello, I am Olivia. How can I help you?" byUserID:kIDOlivia];
    self.showTypingIndicator = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    [self changeStateToStop];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.currentVoiceRequest cancel];
}

# pragma mark - Utility
- (void)parseText:(NSString *)text {
    // Make the call to Olivia API only if the string is not empty
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        __weak typeof(self) weakSelf = self;
        [[ApiAIHelper sharedInstance] parseText:text withResultBlock:^(id response){
            [weakSelf addMessage:[response description] byUserID:kIDOlivia];
        }];
    }
}

#pragma mark - Actions
- (void)toggleListening {
    if (self.isListening) {
        self.isListening = NO;
        [self stopListening];
    } else {
        self.isListening = YES;
        [self startListening];
    }
}

- (void)addMessage:(NSString *)message byUserID:(NSString *)userID {
    // Process only when the message is not empty
    if ([message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && userID) {
        // Show a typing indicator temporarily
        self.showTypingIndicator = YES;
        // Scroll to the bottom to show the indicator
        [self scrollToBottomAnimated:YES];
        
        /**
         *  Allow typing indicator to show
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([userID isEqualToString:kIDUSer]) {
                [self didPressSendButton:nil withMessageText:message
                                senderId:kIDUSer
                       senderDisplayName:kNameUser
                                    date:[NSDate date]];
            } else {
                [self didPressSendButton:nil withMessageText:message
                                senderId:kIDOlivia
                       senderDisplayName:kNameOlivia
                                    date:[NSDate date]];
            }
        });
    }
}

# pragma mark - OLVBubbleMessageViewControllerDelegate

- (void)closePressed:(UIBarButtonItem *)sender {
    [self.delegateModal didDismissViewController:self];
}

#pragma mark - JSQMessagesViewController method overrides
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.model.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
    // Send the text to Voice to text API (input type = text), when user types or 
    if ([senderId isEqualToString:kIDUSer]) {
        [self parseText:text];
    }
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    // This is needed to prevent crash
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.model.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.model.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.model.outgoingBubbleImageData;
    }
    
    return self.model.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.model.messages objectAtIndex:indexPath.item];
    
    return [self.model.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.model.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.model.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.model.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.model.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.model.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.model.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.model.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

# pragma mark - Voice request
- (void)startListening
{
    [self changeStateToListening];
    
    AIVoiceRequest *request = (AIVoiceRequest *)[self.apiAI requestWithType:AIRequestTypeVoice];
    request.useVADForAutoCommit = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addMessage:[request description] byUserID:kIDUSer];
        [strongSelf changeStateToStop];
    } failure:^(AIRequest *request, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [strongSelf changeStateToStop];
    }];
    
    self.currentVoiceRequest = request;
    [self.apiAI enqueue:request];
}

- (void)stopListening
{
    [self changeStateToStop];
    [self.currentVoiceRequest commitVoice];
}

- (void)changeStateToListening
{
    [self.activity startAnimating];
    self.inputToolbar.tintColor = [UIColor redColor];
}

- (void)changeStateToStop
{
    [self.activity stopAnimating];
}

@end
