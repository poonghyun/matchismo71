//
//  CardGameViewController.m
//  Matchismo71
//
//  Created by Mike Lee on 2/20/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardView.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// add gesture recognizers to collection of card views
}

// add swipe method here; does it do both this one and the one in the view

@end
