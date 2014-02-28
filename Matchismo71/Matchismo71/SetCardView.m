//
//  SetCardView.m
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Gesture Handling

- (void)tap:(UITapGestureRecognizer *)gesture
{
    self.selected = !self.selected;
}

#pragma mark - Setters

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(double)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

    if (self.selected) {
        [[UIColor yellowColor] setStroke];
        [roundedRect stroke];
    }

    [self drawSymbols];
}

- (CGFloat)cardWidth { return self.bounds.size.width; }
- (CGFloat)cardHeight { return self.bounds.size.height; }
// the buffer space between the symbol and top/bottom of the card
- (CGFloat)buffer { return [self cardHeight] * 0.15; }
// the buffer space between symbols
- (CGFloat)innerBuffer {return [self cardWidth] * 0.05; }
// horizontal radius of a symbol
- (CGFloat)symbolRadius { return ([self cardWidth] - 2 * [self buffer] - 2 * [self innerBuffer])/6; }
- (CGFloat)symbolWidth { return 2 * [self symbolRadius]; }
- (CGFloat)symbolHeight { return [self cardHeight] - 2 * [self buffer]; }

- (void)drawSymbols
{
    [self.color setStroke];
    // no need to set fill if shading is 0
    if (self.shading == 1) {
        [[self.color colorWithAlphaComponent:0.5] setFill];
    } else if (self.shading == 2) {
        [self.color setFill];
    }

    if (self.number == 0) {
        CGRect center = CGRectMake([self cardWidth]/2 - [self symbolRadius], [self buffer], [self symbolRadius] * 2, [self cardHeight] - 2 * [self buffer]);
        UIBezierPath *centerShape = [self drawShape:center];
        [centerShape stroke];
        [centerShape fill];
    } else if (self.number == 1) {
        CGRect left = CGRectMake([self cardWidth]/2 - [self innerBuffer] * 0.5 - [self symbolWidth], [self buffer], [self symbolWidth], [self symbolHeight]);
        CGRect right = CGRectMake([self cardWidth]/2 + [self innerBuffer] * 0.5, [self buffer], [self symbolWidth], [self symbolHeight]);
        UIBezierPath *leftShape = [self drawShape:left];
        UIBezierPath *rightShape = [self drawShape:right];
        [leftShape stroke];
        [leftShape fill];
        [rightShape stroke];
        [rightShape fill];
    } else if (self.number == 2) {
        CGRect left = CGRectMake([self buffer], [self buffer], [self symbolWidth], [self symbolHeight]);
        CGRect center = CGRectMake([self cardWidth]/2 - [self symbolRadius], [self buffer], [self symbolRadius] * 2, [self cardHeight] - 2 * [self buffer]);
        CGRect right = CGRectMake([self cardWidth] - [self buffer] - [self symbolWidth], [self buffer], [self symbolWidth], [self symbolHeight]);
        
        UIBezierPath *leftShape = [self drawShape:left];
        UIBezierPath *centerShape = [self drawShape:center];
        UIBezierPath *rightShape = [self drawShape:right];
        [leftShape stroke];
        [leftShape fill];
        [centerShape stroke];
        [centerShape fill];
        [rightShape stroke];
        [rightShape fill];
    }
}

- (UIBezierPath *)drawShape:(CGRect)rect
{
    if ([self.symbol isEqualToString:@"oval"]) {
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        return oval;
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        UIBezierPath *squiggle = [[UIBezierPath alloc] init];
        [squiggle moveToPoint:rect.origin];
        [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height) controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height) controlPoint2:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
        [squiggle addCurveToPoint:rect.origin controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y) controlPoint2:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
        [squiggle closePath];
        
        return squiggle;
    } else if ([self.symbol isEqualToString:@"diamond"]) {
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y)];
        [diamond addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height/2)];
        [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)];
        [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2)];
        [diamond closePath];
        
        return diamond;
    } else {
        return nil;
    }
}

@end
