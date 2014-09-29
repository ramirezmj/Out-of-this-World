//
//  OWOuterSpaceTableViewController.m
//  Out of this World
//
//  Created by Jose Manuel Ramirez Martinez on 14/09/14.
//  Copyright (c) 2014 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "OWOuterSpaceTableViewController.h"
#import "AstronomicalData.h"
#import "OWSpaceObject.h"
#import "OWSpaceImageViewController.h"
#import "OWSpaceDataViewController.h"

@implementation OWOuterSpaceTableViewController
#define ADDED_SPACE_OBJECTS_KEY @"Added Space Objects Array"

#pragma mark - Lazy Instantiation of Properties

- (NSMutableArray *)planets
{
    if ( !_planets ) {
        _planets = [[NSMutableArray alloc] init];
    }
    return _planets;
}

- (NSMutableArray *)addedSpaceObjects
{
    if ( !_addedSpaceObjects ) {
        _addedSpaceObjects = [[NSMutableArray alloc] init];
    }
    return _addedSpaceObjects;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
//    We don't need it because of the Lazy Instantiaton pragma mark section
//    self.planets = [[NSMutableArray alloc] init];

    for ( NSMutableDictionary *planetData in [AstronomicalData allKnownPlanets] )
    {
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", planetData[PLANET_NAME]];
        OWSpaceObject *planet = [[OWSpaceObject alloc] initWithData:planetData andImage:[UIImage imageNamed:imageName]];
        [self.planets addObject:planet];
    }
    
    NSArray *myPlanetsAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECTS_KEY];
    for ( NSDictionary *dictionary in myPlanetsAsPropertyLists ) {
        OWSpaceObject *spaceObject = [self spaceObjectForDictionary:dictionary];
        [self.addedSpaceObjects addObject:spaceObject];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", sender);
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
        if ( [segue.destinationViewController isKindOfClass:[OWSpaceImageViewController class]] )
        {
            OWSpaceImageViewController *nextViewController = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            OWSpaceObject *selectedObject;
            
            if ( path.section == 0 ) {
                selectedObject = self.planets[path.row];
            }
            else if ( path.section == 1 ) {
                selectedObject = self.addedSpaceObjects[path.row];
            }
            
            nextViewController.spaceObject = selectedObject;
        }
    }
    
    if ( [sender isKindOfClass:[NSIndexPath class]] )
    {
        if ( [segue.destinationViewController isKindOfClass:[OWSpaceDataViewController class]] )
        {
            OWSpaceDataViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            OWSpaceObject *selectedObject;
            
            if ( path.section == 0 ) {
                selectedObject = self.planets[path.row];
            }
            else if ( path.section == 1 ) {
                selectedObject = self.addedSpaceObjects[path.row];
            }
            
            targetViewController.spaceObject = selectedObject;
        }
    }
    
    if ( [segue.destinationViewController isKindOfClass:[OWAddSpaceObjectViewController class]] ) {
        OWAddSpaceObjectViewController *addSpaceObjectVC = segue.destinationViewController;
        addSpaceObjectVC.delegate = self;
    }
}

#pragma mark - OWAddSpaceObjectViewControllerDelegate

- (void)didCancel
{
    NSLog(@"didCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSpaceObject:(OWSpaceObject *)spaceObject
{
//    We don't need it because of the Lazy Instantiaton pragma mark section
//    if ( !self.addedSpaceObjects ) {
//        self.addedSpaceObjects = [[NSMutableArray alloc] init];
//    }
    [self.addedSpaceObjects addObject:spaceObject];
//    NSLog(@"addSpaceObject");
    
//    Will save to NSUserDefaults here
    NSMutableArray *spaceObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SPACE_OBJECTS_KEY] mutableCopy];
    
    if ( !spaceObjectsAsPropertyLists ) spaceObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    [spaceObjectsAsPropertyLists addObject:[self spaceObjectAsPropertyList:spaceObject]];
    [[NSUserDefaults standardUserDefaults] setObject:spaceObjectsAsPropertyLists forKey:ADDED_SPACE_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // this is telling the table view to reload
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

- (NSDictionary *)spaceObjectAsPropertyList:(OWSpaceObject *)spaceObject
{
    NSData *imageData = UIImagePNGRepresentation(spaceObject.spaceImage);
    NSDictionary *dictionary = @{PLANET_NAME : spaceObject.name, PLANET_GRAVITY : @(spaceObject.gravitationalForce), PLANET_DIAMETER : @(spaceObject.diameter), PLANET_YEAR_LENGTH : @(spaceObject.yearLenght), PLANET_DAY_LENGTH : @(spaceObject.dayLenght), PLANET_TEMPERATURE : @(spaceObject.temperature), PLANET_NUMBER_OF_MOONS : @(spaceObject.numberOfMoons), PLANET_NICKNAME : spaceObject.nickname, PLANET_INTERESTING_FACT : spaceObject.interestFact, PLANET_IMAGE : imageData};
    return dictionary;
}

- (OWSpaceObject *)spaceObjectForDictionary:(NSDictionary *)dictionary
{
    NSData *dataForImage = dictionary[PLANET_IMAGE];
    UIImage *spaceObjectImage = [UIImage imageWithData:dataForImage];
    OWSpaceObject *spaceObject = [[OWSpaceObject alloc] initWithData:dictionary andImage:spaceObjectImage];
    return spaceObject;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [self.addedSpaceObjects count] ) {
        return 2;
    }
    else {
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 1 ) {
        return [self.addedSpaceObjects count];
    }
    else {
        return [self.planets count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //Configure the cell...
    
    if ( indexPath.section == 1) {
        // Use new Space Object to customize our cell
        OWSpaceObject *planet = [self.addedSpaceObjects objectAtIndex:indexPath.row];
        cell.textLabel.text = planet.name;
        cell.detailTextLabel.text = planet.nickname;
        cell.imageView.image = planet.spaceImage;
    }
    else {
        OWSpaceObject *planet = [self.planets objectAtIndex:indexPath.row];
        cell.textLabel.text = planet.name;
        cell.detailTextLabel.text = planet.nickname;
        cell.imageView.image = planet.spaceImage;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Accessory button is working properly in row: %li", indexPath.row);
    [self performSegueWithIdentifier:@"push to space data" sender:indexPath];
}

@end
