//
//  SortChoicesController.m
//  PostVazut
//
//  Created by Adrian Mihai on 5/15/12.
//  Copyright (c) 2012 Adrian Mihai. All rights reserved.
//

#import "SortChoicesController.h"
#import "SortChoicesCell.h"

@interface SortChoicesController ()

@end

@implementation SortChoicesController

@synthesize delegate;
@synthesize filterName;
@synthesize chosenValues;
@synthesize tableView;
@synthesize allowMultipleSelection;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
   }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    postList = [PostList getInstance];
}

- (void) viewWillAppear:(BOOL)animated {

    NSDictionary *filter = [postList getFilterForName:filterName];
    chosenValues = [NSMutableArray arrayWithArray:[filter objectForKey:@"chosen-values"]];

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background2.png"]];
    [tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [tableView setSeparatorColor:[[UIColor alloc] initWithRed:.2 green:.2 blue:.2 alpha:1]];
    
    CGRect frame = self.view.frame;
    frame.origin.x = round(frame.origin.x);
    frame.origin.y = round(frame.origin.y);
    self.view.frame = frame;
    
    [self.view addSubview:tableView];

}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    static NSString *CellIdentifier = @"SortChoicesCell";
    
    SortChoicesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SortChoicesCell" owner:self options:nil];
        for (id currentObject in objects) {
            if ([currentObject isKindOfClass: [UITableViewCell class]]) {
                cell = (SortChoicesCell*)currentObject;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1]];
    cell.textLabel.textColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
    
} 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *filter = [postList getFilterForName:filterName];
    NSString *cellValue = [[filter objectForKey:@"values"] objectAtIndex:indexPath.row];
    
    [chosenValues removeAllObjects];
    [chosenValues insertObject:cellValue atIndex:0];
    
    for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++) {
        SortChoicesCell *loopCell = (SortChoicesCell*)[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (indexPath.row == i) {
            loopCell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_on.png"];
        } else {
            loopCell.checkbox.image = [UIImage imageNamed:@"cell_checkbox_off.png"];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [postList setValues:chosenValues forFilter:filterName];
    [postList filterPosts];
    [self.delegate performSelector:@selector(dismissPopoverWithRefresh)];
    
}

@end
