//
//  GROwner.h
//  GitRepo
//
//  Created by WELLINGTON BARBOSA on 5/25/16.
//  Copyright © 2016 WELLINGTON BARBOSA. All rights reserved.
//
 
#import "MTLModel.h"
#import "Mantle.h"

@interface GROwner : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *login;
@property (copy, nonatomic, readonly) NSString *avatarUrl;

@end
