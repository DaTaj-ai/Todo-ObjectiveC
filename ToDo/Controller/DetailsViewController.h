//
//  DetailsViewController.h
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "EnumUtils.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property Task *globalTask ;
@property (nonatomic, assign) TaskEditingMode editingMode;

@end

NS_ASSUME_NONNULL_END
