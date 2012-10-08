#import "FiltersController.h"

@interface FiltersController ()

@end


@implementation FiltersController

@synthesize delegate;
@synthesize filterChoicesController = _filterChoicesController;
@synthesize actionView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _filterChoicesController = [[FilterChoicesController alloc] initWithNibName:@"FilterChoicesController" bundle:nil];
    _filterChoicesController.delegate = self;
    _filterChoicesController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];

    actionView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    postList = [PostList getInstance];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) viewWillAppear:(BOOL)animated {

    SCNavigationBar* customNavigationBar = (SCNavigationBar*)self.navigationController.navigationBar;
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"back_button_alpha.png"] highlight:nil leftCapWidth:24.0];
    [customNavigationBar setText:@"Back" onBackButton:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if ([self.actionView.subviews count] == 0) {
        
        // Create a custom back button
        UIButton* applyButton = [customNavigationBar actionButton:@"Show movies" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
        [applyButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];        
        // Add an action for going back
        [applyButton addTarget:self action:@selector(applyFilterChoices:) forControlEvents:UIControlEventTouchUpInside];

        
        // Create a custom back button
        UIButton* clearButton = [customNavigationBar actionButton:@"Clear filters" backButtonImage:[UIImage imageNamed:@"button_alpha.png"] highlight:nil];
        // Add an action for going back
        [clearButton addTarget:self action:@selector(clearFilters:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
        [self.actionView addSubview:clearButton];
        [self.actionView addSubview:applyButton];
        
        CGRect clearButtonFrame = clearButton.frame;
        CGRect applyButtonFrame = applyButton.frame;
        
        int totalWidth = clearButtonFrame.size.width + 25 + applyButtonFrame.size.width;
        float pos = (self.view.frame.size.width - totalWidth)/2;
        
        clearButtonFrame.origin.x = round(pos) ;
        clearButtonFrame.origin.y = 10;
        clearButton.frame = clearButtonFrame;

        applyButtonFrame.origin.x = round(clearButtonFrame.origin.x + clearButtonFrame.size.width + 25);
        applyButtonFrame.origin.y = 10;
        applyButton.frame = applyButtonFrame;
        
        
    }
    
    [self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [self setActionView:nil];
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
//    if (section == 0) {
//        return 2;
//    } else if (section == 1) {
//        return 1;
//    }
//    return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilterCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        UITableViewCellStyle style;
        
        if (indexPath.section == 0) {
            
            style = UITableViewCellStyleValue1;
            
        } else if (indexPath.section == 1) {

            style = UITableViewCellStyleDefault;
            
        }
        
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;

   
    [cell.textLabel setFont:[UIFont fontWithName:@"Dosis-Bold" size:14]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Dosis-Bold" size:14]];
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            NSString *chosenValues = [postList getChosenValuesFor:@"categories"];
            cell.textLabel.text = @"Category";
            cell.detailTextLabel.text = chosenValues;

        } else if (indexPath.row == 1) {

            NSString *chosenValues = [postList getChosenValuesFor:@"authors"];
            cell.textLabel.text = @"Post author";
            cell.detailTextLabel.text = chosenValues;
            
        }
        
    } else if (indexPath.section == 1) {

        if (indexPath.row == 0) {

            NSString *chosenValues = [postList getChosenValuesFor:@"sorting"];
            cell.textLabel.text = chosenValues;
            
        } else if (indexPath.row == 1) {
            
        }
        
        
    }
    

    
    
    // Configure the cell...
    
    return cell;
}

- (BOOL) stringExists: (NSString*) str inArray: (NSArray *) arr {
    for (NSString* item in arr)
    {
        if ([item rangeOfString:str].location != NSNotFound) return YES;
    }
    return NO;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return @"Filter by";
//    } else if (section == 1) {
//        return @"Sort results by";
//    }
//    return @"";
//    
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
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
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    [view addSubview:label];
//    
//    return view;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    [cell setBackgroundColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1]];
    cell.textLabel.textColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
    
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
    NSString* filterName;
    BOOL allowMultiple;
    if (indexPath.section == 0) {
        allowMultiple = YES;
        if (indexPath.row == 0) {
            filterName = @"categories";
        } else if (indexPath.row == 1) {
            filterName = @"authors";
        }
    } else if (indexPath.section == 1) {
        allowMultiple = NO;
        filterName = @"sorting";
    }
    _filterChoicesController.filterName = filterName;
    _filterChoicesController.allowMultipleSelection = allowMultiple;
    [_filterChoicesController.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:_filterChoicesController animated:YES];
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)clearFilters:(id)sender
{
    [postList resetFilters];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)applyFilterChoices:(id)sender
{
    [postList filterPosts];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
