//
//  ViewController.m
//  CalculateText
//
//  Created by Uber on 28/10/2020.
//  Copyright © 2020 RXMobile. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *text = @"This is a long sentence. Wonder how much space is needed?";
    UIFont* font = [UIFont fontWithName:@"Arial" size:17];
    float  width = 300;
    
    CFTimeInterval beginTimeBenckmark1 = CFAbsoluteTimeGetCurrent();

    CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
    CGRect frame = [text boundingRectWithSize:boundingSize
                                      options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font }
                                      context:nil];
    CGSize roundedSize1 = CGRectIntegral(CGRectMake(0, 0, frame.size.width, frame.size.height)).size;
    NSLog(@"\t(boundingRectWithSize) \tsuggestedSize: %@ \t| result time = %.5f",NSStringFromCGSize(roundedSize1), CFAbsoluteTimeGetCurrent() - beginTimeBenckmark1);

    
    //------------------------------------------------------------------------------------------//

    
    CFTimeInterval beginTimeBenckmark2 = CFAbsoluteTimeGetCurrent();

    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    [attributesDictionary setObject:font forKey:NSFontAttributeName];
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text attributes:attributesDictionary];

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                        frameSetter, /* Framesetter */
                                                                        CFRangeMake(0, attributedString.length), /* String range (entire string) */
                                                                        NULL, /* Frame attributes */
                                                                        CGSizeMake(width, CGFLOAT_MAX), /* Constraints (CGFLOAT_MAX indicates unconstrained) */
                                                                        NULL /* Gives the range of string that fits into the constraints, doesn't matter in your situation */
                                                                        );
    CGSize roundedSize2 = CGRectIntegral(CGRectMake(0, 0, suggestedSize.width, suggestedSize.height)).size;
    CFRelease(frameSetter);
    NSLog(@"\t(CoreText) \tsuggestedSize: %@ \t| result time = %.5f",NSStringFromCGSize(roundedSize2), CFAbsoluteTimeGetCurrent() - beginTimeBenckmark2);

    
    //------------------------------------------------------------------------------------------//

    
    CFTimeInterval beginTimeBenckmark3 = CFAbsoluteTimeGetCurrent();
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    
    CGSize roundedSize3 = CGRectIntegral(CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)).size;
    NSLog(@"\t(sizeToFit) \tsuggestedSize: %@ \t| result time = %.5f",NSStringFromCGSize(roundedSize3), CFAbsoluteTimeGetCurrent() - beginTimeBenckmark3);

}


@end
