//
//  ViewController.m
//  ContactPresentationBug
//
//  Created by u0032428 on 6/1/17.
//  Copyright © 2017 TRGR. All rights reserved.
//

@import UIKit;
@import ContactsUI;

#import "ViewController.h"
#import "ContactsManager.h"
#import "JERContactViewController.h"

@interface ViewController () <CNContactViewControllerDelegate>

@property (nonatomic, strong) CNContact *contact;
@property (nonatomic, strong) CNContactViewController *contactVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(contactsChanged)
                               name:CNContactStoreDidChangeNotification
                             object:nil];
    
    [[ContactsManager sharedManager] fetchContactsWithCompletion:^(NSArray *contacts) {
        self.contact = [[ContactsManager sharedManager] contactExists:@"Example"];
        
        if (!self.contact) {
            [self addContact];
        }
    }];
}


- (void)contactsChanged {
    [[ContactsManager sharedManager] fetchContactsWithCompletion:^(NSArray *contacts) {
        self.contact = [[ContactsManager sharedManager] contactExists:@"Example"];
    }];
}

- (void)addContact {
    
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.givenName = @"Test";
    contact.familyName = @"Example";
    contact.organizationName = @"Test Organization";
    contact.jobTitle = @"Some Job Title";
    contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[[CNPhoneNumber alloc] initWithStringValue:@"1111111111"]]];
    contact.emailAddresses  = @[[CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"example@some.place"]];
    
    CNSaveRequest *request = [[CNSaveRequest alloc] init];
    [request addContact:contact toContainerWithIdentifier:nil];
    
    NSError *error;
    [[ContactsManager sharedManager].store executeSaveRequest:request error:&error];
}



- (IBAction)presentModallyPressed:(id)sender {
    
}

- (IBAction)presentOnNavStackPressed:(id)sender {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (status == CNAuthorizationStatusAuthorized) {
        
        if (self.contact) {
            
            //JERContactViewController *contactVC = [JERContactViewController viewControllerForContact:self.contact];
            CNContactViewController *contactVC = [CNContactViewController viewControllerForContact:self.contact];
            contactVC.displayedPropertyKeys = @[CNContactNamePrefixKey,
                                                CNContactGivenNameKey,
                                                CNContactMiddleNameKey,
                                                CNContactFamilyNameKey,
                                                CNContactNameSuffixKey,
                                                CNContactNicknameKey,
                                                CNContactOrganizationNameKey,
                                                CNContactDepartmentNameKey,
                                                CNContactJobTitleKey,
                                                CNContactPhoneNumbersKey,
                                                CNContactEmailAddressesKey,
                                                CNContactUrlAddressesKey];
            
            
            contactVC.allowsEditing    = YES;
            contactVC.allowsActions    = YES;
            contactVC.contactStore     = [ContactsManager sharedManager].store;
            contactVC.delegate = self;
            
            [self.navigationController pushViewController:contactVC animated:YES];
            
//            self.contactVC = contactVC;
//            
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactVC];
//            contactVC.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(dismissContactsViewController)]];
//            
//            [self presentViewController:navigationController animated:YES completion: nil];

        }
    }
    
}

- (void)dismissContactsViewController {
    if ([self.contactVC presentingViewController]) {
        [self.contactVC dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - CNContactViewController Delegate Methods

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property {
    return YES;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
