//
//  JSONParser.m
//  GetOnThatBus
//
//  Created by Yi-Chin Sun on 1/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "JSONParser.h"
#import "Reachability.h"

@implementation JSONParser

- (void)getImagesFromHashtagSearch:(NSString *)hashtag
{
    NSMutableArray * photosArray = [NSMutableArray new];
    NSURL * url;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=1080703211.c72c489.2beaba2c15ed41b58a2df695a4bf1d56", hashtag]];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             NSDictionary *instagramData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             NSArray *instagramPostArray = instagramData[@"data"];
             for (NSDictionary *post in instagramPostArray)
             {
                 Photo *newPhoto = [[Photo alloc] initWithDictionary:post];
                 [photosArray addObject:newPhoto];
             }

             [self.delegate didFinishJSONSearchWithMutableArray:photosArray];
         }
         else
         {
             //Added this because my simulator kept giving me a connection error even though Internet was available.
             [self.delegate lostNetworkConnection];
         }
     }];

}

@end
