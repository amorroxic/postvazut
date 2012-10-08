#import "FilterChoicesController.h"
#import "FilterChoicesCell.h"

@interface FilterChoicesController ()

@end

@implementation FilterChoicesController

@synthesize delegate;
@synthesize filterName;
@synthesize chosenValues;
@synthesize tableView;
@synthesize theBottomView;
@synthesize allowMultipleSelection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    xibFile = @"FilterChoicesCell";
    postList = [PostList getInstance];
    
    

}

-(void)displaySmallCell {
    xibFile = @"FilterChoicesCellSmall";
}

- (void) viewWillAppear:(BOOL)animated {
    // Get our custom nav bar
    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;
    
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"back_button_alpha.png"] highlight:nil leftCapWidth:24.0];
    [customNavigationBar setText:@"Back" onBackButton:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    NSDictionary *filter = [postList getFilterForName:filterName];
    chosenValues = [NSMutableArray arrayWithArray:[filter objectForKey:@"chosen-values"]];

//    CGRect frameBottom = CGRectMake(0, 
//                                    self.view.frame.size.height - 
//                                    40,
//                                    self.view.frame.size.width, 
//                                    40);
//    theBottomView = [[UIView alloc] initWithFrame:frameBottom];
//    [theBottomView setBackgroundColor:[[UIColor alloc] initWithRed:.2 green:.2 blue:.2 alpha:1]];
//    [self.view addSubview:theBottomView];
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    //frame.origin.y = self.navigationController.navigationBar.frame.size.height;
    frame.size.height = self.view.frame.size.height -
    self.tabBarController.tabBar.frame.size.height + 4;
    frame.size.width = self.view.frame.size.width;
    
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    [tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [tableView setSeparatorColor:[[UIColor alloc] initWithRed:.2 green:.2 blue:.2 alpha:1]];
    [self.view addSubview:tableView];

    // Create a custom back button
    UIButton* applyButton = [customNavigationBar actionButton:@"Apply" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:applyButton];
    // Add an action for going back
    [applyButton addTarget:self action:@selector(applyFilterChoices:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setView:nil];
    [self setTheBottomView:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *filter = [postList getFilterForName:filterName];
    return [[filter objectForKey:@"values"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilterChoiceCell";
    if (xibFile != nil) CellIdentifier = xibFile;
    
    FilterChoicesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:xibFile owner:self options:nil];
        for (id currentObject in objects) {
            if ([currentObject isKindOfClass: [UITableViewCell class]]) {
                cell = (FilterChoicesCell*)currentObject;
                break;
            }
        }
    }
    
    
    [cell.label setFont:[UIFont fontWithName:@"Dosis-Bold" size:14]];
    
    NSDictionary *filter = [postList getFilterForName:filterName];
    cell.label.text = [[filter objectForKey:@"values"] objectAtIndex:indexPath.row];
    
    if ([postList stringExists:cell.label.text inArray:chosenValues]) {
        cell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_on.png"];
    } else {
        cell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_off.png"];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return [@"Filter name" uppercaseString];
//    
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle = @"sisis";
//    if (sectionTitle == nil) {
//        return nil;
//    }
//    
//    // Create label with section title
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(20, 6, 300, 30);
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1];
//    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    label.shadowOffset = CGSizeMake(0.0, 1.0);
//    [label setFont:[UIFont fontWithName:@"Dosis-Bold" size:14]];
//    label.text = sectionTitle;
//    
//    // Create header view and add label as a subview
//    UIView *titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    [self.tableView addSubview:label];
//    
//    return titleview;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1]];
    cell.textLabel.textColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
    
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
    FilterChoicesCell *cell = (FilterChoicesCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *filter = [postList getFilterForName:filterName];
    NSString *cellValue = [[filter objectForKey:@"values"] objectAtIndex:indexPath.row];
    
    if (allowMultipleSelection) {
        if ([postList stringExists:cellValue inArray:chosenValues]) {
            cell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_off.png"];
            for (NSString*item in chosenValues) {
                if ([item isEqualToString:cellValue]) {
                    [chosenValues removeObject:item];
                    break;
                }
            }
        } else {
            cell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_on.png"];
            [chosenValues insertObject:cellValue atIndex:0];
        }
    } else {

        [chosenValues removeAllObjects];
        [chosenValues insertObject:cellValue atIndex:0];
        
        for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++) {
            FilterChoicesCell *loopCell = (FilterChoicesCell*)[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (indexPath.row == i) {
                loopCell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_on.png"];
            } else {
                loopCell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_off.png"];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)applyFilterChoices:(id)sender
{
    [postList setValues:chosenValues forFilter:filterName];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
