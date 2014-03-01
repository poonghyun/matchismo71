//
//  SetCardGameViewController.m
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Grid.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) NSMutableArray *setCardViews;
@property (weak, nonatomic) IBOutlet UIView *cardSpace;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *gestureRecognizers;
@property (nonatomic) NSUInteger cardCount;
@property (strong, nonatomic) Grid *grid;
@end

@implementation SetCardGameViewController

#pragma mark - Lazy instantiation

- (CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    game.gameType = 1; // 3 card match
    return game;
}

- (NSMutableArray *)setCardViews
{
    if (!_setCardViews) _setCardViews = [[NSMutableArray alloc] init];
    return _setCardViews;
}

- (NSMutableArray *)gestureRecognizers
{
    if (!_gestureRecognizers) _gestureRecognizers = [[NSMutableArray alloc] init];
    return _gestureRecognizers;
}

- (Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    return _grid;
}

#pragma mark - View initialization

#define STARTING_CARDS 20
#define CELL_ASPECT_RATIO 1.5

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self initializeCards];
}

- (void)initializeCards
{
    // initialize all cards
    // set all cards
    // place cards in cardspace (reusable)
    
    self.cardCount = STARTING_CARDS;
    
    for (int i = 0; i < 81; i++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        [self.setCardViews addObject:cardView];
    }
    
    for (SetCardView *cardView in self.setCardViews) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.setCardViews indexOfObject:cardView]];
        if ([card.color isEqualToString:@"red"]) {
            cardView.color = [UIColor redColor];
        } else if ([card.color isEqualToString:@"green"]) {
            cardView.color = [UIColor greenColor];
        } else if ([card.color isEqualToString:@"blue"]) {
            cardView.color = [UIColor blueColor];
        }
        cardView.number = card.number;
        cardView.shading = card.shading;
        cardView.symbol = card.symbol;
        cardView.selected = NO;
        cardView.matched = NO;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [cardView addGestureRecognizer:gesture];
        [self.gestureRecognizers addObject:gesture];
    }
    
//    NSLog(@"%@", ((SetCardView *)self.setCardViews[20]).symbol);
    
    [self placeCardsInGrid];
}

- (void)placeCardsInGrid
{
    // set grid properties
    self.grid.cellAspectRatio = CELL_ASPECT_RATIO;
    self.grid.size = self.cardSpace.frame.size;
    self.grid.minimumNumberOfCells = self.cardCount;
    
    // calculate buffer space between cards
    float freespaceX = fmodf(self.cardSpace.frame.size.width, self.grid.cellSize.width);
    float freespaceY = fmodf(self.cardSpace.frame.size.height, self.grid.cellSize.height);
    float bufferX = freespaceX / (self.grid.columnCount - 1);
    float bufferY = freespaceY / (self.grid.rowCount -1);
    
    int cardsPlaced = 0;
    int cardViewIndex = 0;
    // place cards in grid
    for (int row = 0; row < self.grid.rowCount; row++) {
        for (int col = 0; col < self.grid.columnCount; col++)
        {
            if (cardsPlaced < self.cardCount) {
                // get next unmatched cardview
                SetCardView *cardView = self.setCardViews[cardViewIndex];
                while (cardView.matched) {
                    cardViewIndex++;
                    cardView = self.setCardViews[cardViewIndex];
                }
                // set size
                cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                // place in cell
                CGPoint gridCenter = [self.grid centerOfCellAtRow:row inColumn:col];
                cardView.center = CGPointMake(gridCenter.x + bufferX * col, gridCenter.y + bufferY * row);
                // add to the board
                [self.cardSpace addSubview:cardView];
            
                cardViewIndex++;
                cardsPlaced++;
            }
        }
    }

}

#pragma mark - Gestures

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    int chosenButtonIndex = [self.gestureRecognizers indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    SetCardView *cardView = (SetCardView *)self.setCardViews[chosenButtonIndex];
    cardView.selected = !cardView.selected;
    for (SetCardView *card in self.cardSpace.subviews) {
        // if not chosen make it unchosen
        // if matched remove from superview and redraw grid
        
//        if (![self.game cardAtIndex:i].isChosen) {
//            cardView.selected = NO;
//        }
//        if ([self.game cardAtIndex:i].isMatched) {
//            self.cardCount -= 1;
//            [UIView animateWithDuration:1.0
//                                  delay:0.0
//                                options:UIViewAnimationOptionCurveLinear
//                             animations:^{ cardView.alpha = 0.0; }
//                             completion:^(BOOL ended){
//                                 if (ended) {
//                                     [cardView removeFromSuperview];
//                                 } }];
//        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Miscellaneous

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

#pragma mark - Redeal and add card

//- (IBAction)moreCards:(UIButton *)sender {
//    // add three cards to cardspace view if valid
//    for (int i = 0; i < 3; i++) {
//        SetCardView * cardView = self.setCardViews[self.cardCount + i];
//        [self.cardSpace addSubview:cardView];
//    }
//    self.cardCount += 3;
//}

//- (IBAction)redeal {
//    self.game = nil;
//    self.gestureRecognizers = nil;
//    self.grid = nil;
//    self.setCardViews = nil;
//    for (SetCardView *subview in self.cardSpace.subviews) {
//        [subview removeFromSuperview];
//    }
//    [self initializeCards];
//}

@end
