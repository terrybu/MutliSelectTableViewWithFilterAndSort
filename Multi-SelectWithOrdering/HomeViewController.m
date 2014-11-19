//
//  HomeViewController.m
//  Multi-SelectWithOrdering
//
//  Created by Aditya Narayan on 11/13/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeViewController.h"
#import "Fruit.h"

@interface HomeViewController () {
    NSMutableArray *dataArray;
    NSMutableArray *fruitsArray;
    NSMutableArray *searchResults;
    NSMutableArray *selectedObjects;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    fruitsArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]initWithObjects:@"Apple", @"Grape", @"Blueberry", @"Strawberry", @"Banana", @"Mango", @"Pineapple", @"Watermelon", nil];
    
    for (int i=0; i < dataArray.count; i++) {
        Fruit *fruit = [[Fruit alloc]init];
        fruit.name = dataArray[i];
        [fruitsArray addObject:fruit];
    }
    
    //Setting up searchbar filter functionality
    searchResults = [NSMutableArray arrayWithCapacity:[fruitsArray count]];
    selectedObjects = [[NSMutableArray array]init];
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Search Bar Methods
- (void)filterContentForSearchText:(NSString*)searchText scope: (NSString *) scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", searchText];
    searchResults = [[fruitsArray filteredArrayUsingPredicate:resultPredicate]mutableCopy];
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [tableView reloadData];
    [self.tableView reloadData];
    //these two lines make sure that both Filterview and Tableview data are refreshed - without it, it doesn't work
}





#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return fruitsArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    Fruit *selectedFruit;
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        //if we are in regular table view
        
        selectedFruit = [fruitsArray objectAtIndex:indexPath.row];

        if (selectedFruit.checkmarkFlag == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //this line solved issue of cells not being selected correctly when we go from "filter tableview" to "regular tableview"
            //the issue happened because whenever we came back to regular table view, the ones that are "checked marked" wouldn't be selected,
            //so "didDESELECT" method wouldn't get properly called when we click on them from reg tableview 
        }
        else if (selectedFruit.checkmarkFlag == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = selectedFruit.name;
    }
    else {
        //if we are in filter search results view
        selectedFruit = [searchResults objectAtIndex:indexPath.row];
        if (selectedFruit.checkmarkFlag == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (selectedFruit.checkmarkFlag == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = selectedFruit.name;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //to make sure there's no gray highlighting when it's clicked - important
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Fruit *selectedFruit;
    
    //if its filterview mode
    if (tableView == self.searchDisplayController.searchResultsTableView){
        selectedFruit = [searchResults objectAtIndex:indexPath.row];
        if (selectedFruit.checkmarkFlag == YES) {
            selectedFruit.checkmarkFlag = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedObjects removeObject:selectedFruit];
        }
        else {
            selectedFruit.checkmarkFlag = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedObjects addObject:selectedFruit];
        }
    }
    
    //if its just regular tableview mode, and you selected something
    //this can get tricky because you might be in this regular tableview when you are
    // 1) first time you are seeing the tableview
    // 2) You came back to the regular tableview after using the filter view
    // so we need logic to take care of both cases
    
    else {
        selectedFruit = [fruitsArray objectAtIndex:indexPath.row];
        selectedFruit.checkmarkFlag = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedObjects addObject:selectedFruit];
    }
    
    
    NSLog(@"%@", selectedObjects);
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Fruit *selectedFruit = [fruitsArray objectAtIndex:indexPath.row];
    selectedFruit.checkmarkFlag = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [selectedObjects removeObject:fruitsArray[indexPath.row]];
    
    NSLog(@"%@", selectedObjects);

}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)segCtrlAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    switch (selectedSegment) {
        case 0:
            NSLog(@"first");
            break;
        case 1:
            NSLog(@"second");
            break;
        default:
            break;
    }
    
}



@end
