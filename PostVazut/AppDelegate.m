#import "AppDelegate.h"
#import "Switch3DTransition.h"
#import "FlipTransition.h"
#import "RotateTransition.h"
#import "ClothTransition.h"
#import "DoorsTransition.h"
#import "NimbusCore.h"
#import "NimbusNetworkImage.h"
#import "SCNavigationBar.h"
#import "Timer.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize postListNavigationController = _postListNavigationController;
@synthesize loadingViewController = _loadingViewController;
@synthesize postListController = _postListController;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Timer setDebug:YES];
    [Timer start];

    [Timer lapse:@"[AppDelegate didFinishLaunchingWithOptions] Creating controllers."];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[HMGLTransitionManager sharedTransitionManager];
    [[Nimbus networkOperationQueue] setMaxConcurrentOperationCount:1];
    
    _loadingViewController = [[Loader alloc] initWithNibName:@"Loader" bundle:nil];
    _loadingViewController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];

    _postListController = [[PostListController alloc] initWithNibName:@"PostListController" bundle:nil];
    _postListController.delegate = self;
    _postListController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    [view addSubview:_loadingViewController.view];
    [self.window addSubview:view];
    
    appIsLoading = YES;
    
    [Timer lapse:@"[AppDelegate didFinishLaunchingWithOptions] Loading posts."];
    [self loadThreadedPosts];
    
    self.window.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
        
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void) loadThreadedPosts {

    NSOperationQueue *queue = [NSOperationQueue new];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadPosts) object:nil];
	[queue addOperation:operation];

}

-(void) loadPosts {
    postList = [PostList getInstance];
    postList.delegate = self;
    [postList updatePosts];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	//NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
}

-(void) postListLoaded {
    
    [Timer lapse:@"[AppDelegate postListLoaded] Posts loaded."];
    
    appIsLoading = false;
	UIView *containerView = [_loadingViewController.view superview];
    [_loadingViewController.view removeFromSuperview];
        
    Switch3DTransition *t1 = [[Switch3DTransition alloc] init];
    t1.transitionType = Switch3DTransitionLeft;
    
    //Switch3DTransition *t2 = [[Switch3DTransition alloc] init];
    
    FlipTransition *t3 = [[FlipTransition alloc] init];
    t3.transitionType = FlipTransitionRight;		
    
    ClothTransition *t4 = [[ClothTransition alloc] init];
    //FlipTransition *t5 = [[FlipTransition alloc] init];
    //RotateTransition *t6 = [[RotateTransition alloc] init];
    //DoorsTransition *t7 = [[DoorsTransition alloc] init];
    
    

    //NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    //CustomNavigationController *nav1 = [[CustomNavigationController alloc] initWithRootViewController:_postListController];
    
    UINavigationController *navigationController = [self customizedNavigationController];
    [navigationController setViewControllers:[NSArray arrayWithObject:_postListController]];
    
    //CustomNavigationController *nav2 = [[CustomNavigationController alloc] initWithRootViewController:_filtersController];
    
    //[controllers addObject:nav1];
    
    //UITabBarController *tabBar = [[UITabBarController alloc] init];
    //tabBar.viewControllers = controllers;
    //tabBar.customizableViewControllers = controllers;    
   
    //[tabBar setSelectedIndex:0];
    
    //[nav1.tabBarItem setImage:[UIImage imageNamed:@"112-group.png"]];
    //[nav2.tabBarItem setImage:[UIImage imageNamed:@"29-heart.png"]];
    //nav1.tabBarItem.title = @"Movie list";
    //nav2.tabBarItem.title = @"Filters";
    
    [[HMGLTransitionManager sharedTransitionManager] setTransition:t4];	
	[[HMGLTransitionManager sharedTransitionManager] beginTransition:containerView];
    
	//_loadingViewController.view.frame = tabBar.view.frame;
	//[_loadingViewController.view removeFromSuperview];	
	[containerView addSubview:navigationController.view];
    
	[[HMGLTransitionManager sharedTransitionManager] commitTransition];
    [self setNavigationController:navigationController];
    [[self window] setRootViewController:navigationController];
	
    //self.window.rootViewController = nav1;
    
//    UIView* ctrl = [[UIView alloc] initWithFrame:nav1.navigationBar.bounds];
//    ctrl.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"postlistback.png"]];
//    ctrl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [nav1.navigationBar addSubview:ctrl];
    
}


- (UINavigationController *)customizedNavigationController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];
    
    // Ensure the UINavigationBar is created so that it can be archived. If we do not access the
    // navigation bar then it will not be allocated, and thus, it will not be archived by the
    // NSKeyedArchvier.
    [navController navigationBar];
    
    // Archive the navigation controller.
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:navController forKey:@"root"];
    [archiver finishEncoding];
    
    // Unarchive the navigation controller and ensure that our UINavigationBar subclass is used.
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [unarchiver setClass:[SCNavigationBar class] forClassName:@"UINavigationBar"];
    UINavigationController *customizedNavController = [unarchiver decodeObjectForKey:@"root"];
    [unarchiver finishDecoding];
    
    // Modify the navigation bar to have a background image.
    SCNavigationBar *navBar = (SCNavigationBar *)[customizedNavController navigationBar];
    //[navBar setTintColor:[UIColor colorWithWhite:0 alpha:0]];
    navBar.layer.contents = (id)[UIImage imageNamed:@"transparent_header.png"].CGImage;

    //[navBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.png"]]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"postvazut_navbar3.png"] forBarMetrics:UIBarMetricsDefault];
        
    return customizedNavController;
}


-(void) postListUpdated {
    [self.postListController postsRefreshed];
}

-(void) postListFailed {
    //try at least to show the local posts
    if ([postList doPostsExist] && appIsLoading) {
        [self postListLoaded];
    }
    [self.postListController postsFailed];
}

-(Post*)getPostAtIndex:(int)index {
    Post *post = [postList getPostAtIndex:index];
    return post;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PostVazut" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PostVazut.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) recreatePersistentObjects {
    
    NSError *error;
    NSPersistentStoreCoordinator *storeCoordinator = self.persistentStoreCoordinator;
    for (NSPersistentStore *store in storeCoordinator.persistentStores) {
        NSURL *storeURL = store.URL;
        [storeCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    }
    
    __managedObjectModel = nil;
    __managedObjectContext = nil;
    __persistentStoreCoordinator = nil;
}

@end
