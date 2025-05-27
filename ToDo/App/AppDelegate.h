//
//  AppDelegate.h
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

