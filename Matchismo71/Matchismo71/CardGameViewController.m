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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// add gesture recognizers to collection of card views
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (IBAction)touchDealButton {
    self.game = nil;
    // need a redraw?
}

// abstract
- (Deck *)createDeck
{
    return nil;
}

@end
