//
//  GRGitHubBO.h
//  GitRepo
//
//  Created by WELLINGTON BARBOSA on 5/24/16.
//  Copyright © 2016 WELLINGTON BARBOSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRRepositories.h"

@interface GRGitHubBO : NSObject

+ (void)searchRepositoriesWith:(NSString *)search atPage: (NSInteger) page
                               success:(void(^)(GRRepositories *repositories))success
                               failure:(void(^)(NSError *error))failure;

+ (void)searchPullRequestWithOwner:(NSString *)owner andRepository: (NSString *) repository
                           success:(void(^)(NSArray *pullRequests))success
                           failure:(void(^)(NSError *error))failure;

@end
