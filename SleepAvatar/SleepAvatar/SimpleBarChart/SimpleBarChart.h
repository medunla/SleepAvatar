//
//  SimpleBarChart.h
//  YouLogReading
//
//  Created by Mohammed Islam on 9/18/13.
//  Copyright (c) 2013 KSI Technology, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@class SimpleBarChart;

@protocol SimpleBarChartDataSource <NSObject>

@required

- (NSUInteger)numberOfBarsInBarChart:(SimpleBarChart *)barChart;
- (CGFloat)barChart:(SimpleBarChart *)barChart valueForBarAtIndex:(NSUInteger)index;

@optional

- (UIColor *)barChart:(SimpleBarChart *)barChart colorForBarAtIndex:(NSUInteger)index;

@end

@protocol SimpleBarChartDelegate <NSObject>

@optional

- (void)animationDidEndForBarChart:(SimpleBarChart *)barChart;

@end

@interface SimpleBarChart : UIView
{
	__weak id <SimpleBarChartDataSource> _dataSource;
	__weak id <SimpleBarChartDelegate> _delegate;
    
	NSNumber *_maxHeight;
	NSNumber *_minHeight;
	NSMutableArray *_barHeights;
	NSMutableArray *_barLabels;
	NSInteger _topValue;
	NSInteger _numberOfBars;
	
    
	// Bars
	CALayer *_barLayer;
	NSMutableArray *_barPathLayers;
    
	// Grid
	CALayer *_gridLayer;
	CAShapeLayer *_gridPathLayer;
    
}

@property (weak, nonatomic) id <SimpleBarChartDataSource> dataSource;
@property (weak, nonatomic) id <SimpleBarChartDelegate> delegate;

@property (nonatomic, assign) CGFloat animationDuration; // How long the entire drawing will take
@property (nonatomic, assign) UIColor *chartBorderColor;

// Control Bars
@property (nonatomic, assign) CGFloat barWidth; // Space inbetween the bars
@property (nonatomic, assign) CGFloat barAlpha;


- (void)reloadData;

@end
