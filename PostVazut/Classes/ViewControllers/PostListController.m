#import "PostListController.h"
#import "PostListCell.h"

@interface PostListController ()

@end

@implementation PostListController

@synthesize postViewController = _postViewController;
@synthesize sortController = _sortController;
@synthesize delegate;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize filtersController  = _filtersController;
@synthesize popoverController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_orientation = UIInterfaceOrientationPortrait;
    
    self.postViewController = [[PostViewController alloc] init];
    //self.postViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.postViewController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    

    _filtersController = [[FiltersController alloc] initWithNibName:@"FiltersController" bundle:nil];
    _filtersController.delegate = self;
    _filtersController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
//    
//    mySearchBar = [[UISearchBar alloc] init];
//    mySearchBar.placeholder = @"Search";
//    mySearchBar.tintColor = [UIColor blackColor];
//    mySearchBar.showsCancelButton = YES;
//    
//    mySearchBar.delegate = self;
//    
//    [mySearchBar sizeToFit];
//    bSearchIsOn = NO;
//    
//    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    [mySearchBar sizeToFit];
    
    UIImageView *searchBarOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background2.png"]];
    searchBarOverlay.frame = CGRectMake(-8, -2, 328, 50);
    [searchBar addSubview:searchBarOverlay];
    [searchBar sendSubviewToBack:searchBarOverlay];
    
    for (UIView *v in [searchBar subviews]) {
        
        if ([NSStringFromClass([v class]) isEqualToString:@"UISearchBarBackground"])
        {
            [searchBar sendSubviewToBack:v];
        }
        
        if ([NSStringFromClass([v class]) isEqualToString:@"UIImageView"] & (v != searchBarOverlay))
        {
            [searchBar sendSubviewToBack:v];
        }
    }    

    postList = [PostList getInstance];

    [self setupSortPopover];
    
}

- (UISearchDisplayController *) searchDisplayController {

    UISearchDisplayController *searchCon = [[UISearchDisplayController alloc]
                                            initWithSearchBar:mySearchBar
                                            contentsController:self ];
    searchCon.searchResultsDataSource = self;
    searchCon.searchResultsDelegate = self;
    
    return searchCon;
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.title = @"";

    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;

    // Create a custom back button
    UIButton* filterButton = [customNavigationBar actionButton:@"Filter" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    // Add an action for going back
    [filterButton addTarget:self action:@selector(filterList:) forControlEvents:UIControlEventTouchUpInside];
    
    // Create a custom back button
    UIButton* sortButton = [customNavigationBar actionButton:@"Sort" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sortButton];
    // Add an action for going back
    [sortButton addTarget:self action:@selector(sortDialog:) forControlEvents:UIControlEventTouchUpInside];
    
//
//    // Create a custom back button
//    UIButton* searchButton = [customNavigationBar actionButton:@"Search" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
//    // Add an action for going back
//    [searchButton addTarget:self action:@selector(searchList:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
    
    
//    if ([postList listIsFiltered]) {
//        
//        // Create a custom back button
//        UIButton* clearButton = [customNavigationBar actionButton:@"Show all" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
//        // Add an action for going back
//        [clearButton addTarget:self action:@selector(clearFilters:) forControlEvents:UIControlEventTouchUpInside];
//        [self.tableView reloadData];
//        
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//    
    
    
}

- (void) searchBar: (id) object
{
    bSearchIsOn = ! bSearchIsOn;
    
    if (bSearchIsOn)
    {
        self.tableView.tableHeaderView = mySearchBar; // show the search bar on top of table
    }
    else
    {
        self.tableView.tableHeaderView = nil;
        [mySearchBar resignFirstResponder ];
    }
    
    [self.tableView scrollRectToVisible:[[self.tableView tableHeaderView] bounds] animated:NO]; // scroll to top so we see the search bar
}

- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar
{
    int len = [ [mySearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    
    if (len > 2)
    {
        [self searchTableView];
    }
    else
    {
        [ mySearchBar resignFirstResponder ];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Titlu1"
//                                                        message:@"Search term needs to be at least 3 characters in length."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
    }
}

- (void) searchTableView
{
    NSString                *searchText = mySearchBar.text;
    
    if ([searchText length] > 0)
    {
        // do the actual search....
    }
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    if (bSearchIsOn){
        rows = [postList getSearchResultsCount];
    }
    else{
        rows = [postList postsCount];
    }    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier;
    static NSString *NIBName;
    CellIdentifier= @"Cell_Portrait";
    NIBName = @"PostListCell_Portrait";
    
    PostListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NIBName owner:self options:nil];
        for (id currentObject in objects) {
            if ([currentObject isKindOfClass: [UITableViewCell class]]) {
                cell = (PostListCell*)currentObject;
                break;
            }
        }
    }

    Post *post;
        
    if (bSearchIsOn){
        post = [postList getPostWithSearchAtIndex:indexPath.row];
    }
    else{
        post = [postList getPostAtIndex:indexPath.row];
    }    
    
    [cell setDetailWithPostItem:post];
    
    return cell;
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [postList searchPostsForString:searchString];
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    bSearchIsOn = YES;
    controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    controller.searchResultsTableView.backgroundColor = [UIColor blackColor];
    [self dismissPopover];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    bSearchIsOn = NO;
    [self.tableView scrollRectToVisible:[[self.tableView tableHeaderView] bounds] animated:NO];    
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissPopover];
    if (bSearchIsOn) {
        _postViewController.thePost = [postList getPostWithSearchAtIndex:indexPath.row];
    } else {
        _postViewController.thePost = [postList getPostAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:_postViewController animated:YES];
    
}

- (IBAction)clearFilters:(id)sender
{
    [postList resetFilters];
    self.navigationItem.rightBarButtonItem = nil;    
    [self.tableView reloadData];
}

- (IBAction)filterList:(id)sender
{
    [self dismissPopover];
    [self.navigationController pushViewController:_filtersController animated:YES];
}

- (IBAction)searchList:(id)sender
{
//    if ([self.searchDisplayController.searchBar isHidden]) {
//        //self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
//        self.searchDisplayController.searchBar.hidden = NO;
//    } else {
//        self.searchDisplayController.searchBar.hidden = YES;
//        //self.tableView.tableHeaderView = nil;
//        
//        //[self.searchDisplayController.searchBar resignFirstResponder ]; 
//    }
    [self.tableView scrollRectToVisible:[[self.tableView tableHeaderView] bounds] animated:NO];    
}


- (void)refresh {
    [postList refreshPosts];
}

-(void) postsRefreshed {
//    CGRect frame = self.tableView.frame;
//    frame.origin.y = self.navigationController.navigationBar.frame.size.height;
//    self.tableView.frame = frame;
    
    [self.tableView reloadData];
    [super stopLoading];
}

-(void) postsFailed {
    if (isLoading) [super stopLoading];
}

-(void) setupSortPopover {
    _sortController = [[SortChoicesController alloc] init];
    _sortController.delegate = self;
    _sortController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    _sortController.filterName = @"sorting";
    _sortController.allowMultipleSelection = NO;
    _sortController.contentSizeForViewInPopover = CGSizeMake(174, 44*3);
    [_sortController.tableView reloadData];
    
}

- (IBAction)sortDialog:(id)sender
{
    //UIButton *sortButton = (UIButton *)sender;

	if (self.popoverController != nil) {
        [self dismissPopover];
	} else {
        CGRect frame = CGRectMake(0, 0, 50, 54);
        
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:_sortController];
        [self.popoverController presentPopoverFromRect:frame
                                                inView:self.parentViewController.view 
                              permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp
                                              animated:NO];
        frame = self.popoverController.view.frame;
        frame.origin.x = round(frame.origin.x);
        frame.origin.y = round(frame.origin.y);
        self.popoverController.view.frame = frame;
        
    }
    
}

-(void)dismissPopover {
    [self.popoverController dismissPopoverAnimated:NO];
    self.popoverController = nil;
}
-(void)dismissPopoverWithRefresh {
    [self dismissPopover];
    [self.tableView reloadData];
}


- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {

}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    return YES;
}

@end
