#import <UIKit/UIKit.h>
#import "PostListController.h"
#import "Loader.h"
#import "PostList.h"
#import "HMGLTransitionManager.h"
#import "FiltersController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PostListProtocol> {
    PostList* postList;
    BOOL appIsLoading;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Loader *loadingViewController;
@property (nonatomic, retain) PostListController *postListController;
@property (nonatomic, retain) UINavigationController *postListNavigationController;
@property (nonatomic, retain) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)recreatePersistentObjects;

@end
