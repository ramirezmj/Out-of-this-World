//
//  OWSpaceImageViewController.m
//  Out of this World
//
//  Created by Jose Manuel Ramirez Martinez on 15/09/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "OWSpaceImageViewController.h"

@implementation OWSpaceImageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Jupiter.jpg"]];
    self.scrollView.contentSize = self.imageView.frame.size;
    [self.scrollView addSubview:self.imageView];
}

@end
