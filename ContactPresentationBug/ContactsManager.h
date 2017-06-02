//
//  ContactPresentationBug
//
//  Copyright 2017 Thomson Reuters. All Rights Reserved. Proprietary and 
//  Confidential information of Thomson Reuters. Disclosure, Use or Reproduction 
//  without the written authorization of Thomson Reuters is prohibited.
//

@import UIKit;
@import ContactsUI;

typedef void(^ContactFetchCompletionBlock)(NSArray *contacts);

@interface ContactsManager : NSObject

@property (readonly,nonatomic) CNContactStore *store;

+ (ContactsManager *)sharedManager;
- (void)fetchContactsWithCompletion:(ContactFetchCompletionBlock)completionBlock;

- (CNContact *)contactExists:(NSString *)identifier;

@end
