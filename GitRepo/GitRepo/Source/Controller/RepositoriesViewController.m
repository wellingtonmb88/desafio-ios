//
//  RepositoriesViewController.m
//  GitRepo
//
//  Created by WELLINGTON BARBOSA on 5/24/16.
//  Copyright © 2016 WELLINGTON BARBOSA. All rights reserved.
//

#import <UIScrollView+InfiniteScroll.h>
#import "RepositoriesViewController.h"
#import "GRGitHubManager.h"
#import "GRRepositories.h"
#import "GRRepository.h"
#import "GRRepositoryTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIAlertController+Utils.h"

@interface RepositoriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchController *searchController;

@property (strong, nonatomic) GRGitHubManager *manager;
@property (strong, nonatomic) GRRepositories * repositories;
@property (strong, nonatomic) NSArray * pullRequests;
@property (strong, nonatomic) NSString * searchVaue;
@property (nonatomic) int pageCount;

@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
    [self setupInfiniteScroll];
}

#pragma mark - Getters/Setters

- (GRGitHubManager *)manager {
    if (!_manager) {
        _manager = [GRGitHubManager new];
    }
    
    return _manager;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(searchBar.text != nil && [searchBar.text length] > 0){
        self.searchVaue = searchBar.text;
        _pageCount = 1;
        [self searchRepository];
    }
}

#pragma mark - Actions

- (void) setupSearchController {
    // Search controller
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = NSLocalizedString(@"alertcontroller.title.searchrepository", @"Search Repository");
    
    _searchController.hidesNavigationBarDuringPresentation = false;
    _searchController.dimsBackgroundDuringPresentation = false;
    
    // Add the search bar
    self.definesPresentationContext = NO;
    [_searchController.searchBar sizeToFit];
    
    self.navigationItem.titleView = _searchController.searchBar;
}

- (void) setupInfiniteScroll {
    
    // change indicator view style to white
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    
    typeof(self) __weak __block weakSelf = self;
    // setup infinite scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        
        typeof(weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        _pageCount+=1;
        [strongSelf searchRepository];
        
        // finish infinite scroll animation
        [tableView finishInfiniteScroll];
    }];
}

- (void)searchRepository{
    [self showProgress];
    
    typeof(self) __weak __block weakSelf = self;
    
    [self.manager searchRepositoriesWith:self.searchVaue atPage:_pageCount withCompletionBlock:^(GRRepositories * repositories, BOOL success) {
        
        typeof(weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if(success){
            
            if(repositories == nil || [repositories.items count] < 1){
                [strongSelf createAndShowAlerView:NSLocalizedString(@"alertcontroller.title.error", @"Error")
                                      withMessage:NSLocalizedString(@"alertcontroller.message.noacronymfound", @"No Acronym found!")];
            }else {
                strongSelf.repositories = repositories;
                [strongSelf.tableView reloadData];
            }
            
        } else {
            [strongSelf createAndShowAlerView:NSLocalizedString(@"alertcontroller.title.error", @"Error") withMessage:NSLocalizedString(@"alertcontroller.message.requestfailure", @"Request Failure!")];
        }
        
        [strongSelf hideProgress];
        
    }];
}

-(void) createAndShowAlerView:(NSString*) title withMessage:(NSString*)message {
    
    UIAlertController *alertController = [UIAlertController createAndShowAlertWithTitle:title withMessage:message hasDefaultAction:YES];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void) showProgress {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"mbprogresshud.label", @"Loading...");
}

- (void) hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Table View Data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _repositories.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Table View Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellRepository";
    
    GRRepositoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GRRepositoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureCellWithRepository:_repositories.items[[indexPath row]]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showPullRequestsSegue"]){
        
        NSInteger index = [[self.tableView indexPathForSelectedRow] row]; 
        GRRepository *repository = _repositories.items[index];
    }
}


@end
