//
//  OWAddSpaceObjectViewController.m
//  Out of this World
//
//  Created by Jose Manuel Ramirez Martinez on 21/09/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "OWAddSpaceObjectViewController.h"

@interface OWAddSpaceObjectViewController ()

@end

@implementation OWAddSpaceObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *orionImage = [UIImage imageNamed:@"Orion.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:orionImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.delegate didCancel];

}

- (IBAction)addButtonPressed:(UIButton *)sender
{
    [self.delegate addSpaceObject];
    
}
@end
