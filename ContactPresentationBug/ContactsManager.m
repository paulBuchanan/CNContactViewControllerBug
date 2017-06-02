//
//  ContactPresentationBug
//
//  Copyright 2017 Thomson Reuters. All Rights Reserved. Proprietary and 
//  Confidential information of Thomson Reuters. Disclosure, Use or Reproduction 
//  without the written authorization of Thomson Reuters is prohibited.
//

#import "ContactsManager.h"
#import <Contacts/Contacts.h>
@import ContactsUI;

#define kContactKeyArray @[ CNContactPhoneNumbersKey, \
                            CNContactEmailAddressesKey, \
                            CNContactUrlAddressesKey, \
                            CNContactOrganizationNameKey, \
                            CNContactDepartmentNameKey, \
                            CNContactJobTitleKey, \
                            [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], \
                            [CNContactViewController descriptorForRequiredKeys]]

@interface ContactsManager()

@property (nonatomic, strong) CNContactStore *store;
@property (nonatomic, strong) NSMutableArray<CNContact *> *contacts;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ContactsManager

static ContactsManager *sharedManager;

+ (ContactsManager *)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [[CNContactStore alloc] init];
        _lock = [[NSLock alloc] init];
        _contacts = [NSMutableArray array];
    }
    return self;
}


- (void)fetchContactsWithCompletion:(ContactFetchCompletionBlock)completionBlock {
    [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
            
                if ([self.lock tryLock]) {
                    
                    [self.contacts removeAllObjects];
                    
                    __weak ContactsManager *weakSelf = self;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        // This is thread safe, and according to the docs should be run on a background thread due to potental blocking I/O
                        CNContactFetchRequest *cfr          = [[CNContactFetchRequest alloc] initWithKeysToFetch:kContactKeyArray];
                        NSError *err                        = nil;
                        
                        BOOL success = [self.store enumerateContactsWithFetchRequest:cfr error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                            
                            [weakSelf.contacts addObject:contact];
                        }];
                        
                        if (success) {
                            NSLog(@"fetchContacts - complete");
                        }
                        else {
                            NSLog(@"fetchContacts - failure");
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactsHaveChangedNotification" object:nil];
                            [self.lock unlock];
                            if (completionBlock) {
                                completionBlock(self.contacts);
                            }
                        });
                    });
                }
            } else {
                NSLog(@"Contacts access disallowed by user");
            }
        });
    }];
}

- (CNContact *)contactExists:(NSString *)lastName {
    for (CNContact *contact in self.contacts) {
        if ([contact.familyName isEqualToString:lastName]) {
            return contact;
        }
    }
    return nil;
}

@end
