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

    
    //------------------------------------------------------------------------------------------//
   
    /*
    (boundingRectWithSize)   suggestedSize: {284, 38}     | result time = 0.00294
    (CoreText)               suggestedSize: {279, 39}     | result time = 0.00056
    (intrinsicContentSize)   suggestedSize: {284, 38}     | result time = 0.00137
    */
    
    
   //(boundingRectWithSize)     suggestedSize: {284, 38}     | result time = 0.00846
   //(CoreText)                 suggestedSize: {279, 39}     | result time = 0.00179
   //(intrinsicContentSize)     suggestedSize: {284, 38}     | result time = 0.00318

    
    //------------------------------------------------------------------------------------------//

    
    /*
    for (NSNumber *n in @[@(12.0f), @(14.0f), @(18.0f)]) {
        CGFloat fontSize = [n floatValue];
        CGRect r = [text boundingRectWithSize:CGSizeMake(200, 0)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                      context:nil];
        NSLog(@"fontSize = %f\tbounds = (%f x %f)",
              fontSize,
              r.size.width,
              r.size.height);
    }
    */
    
    //------------------------------------------------------------------------------------------//
    // or
    // CGSize textSize = [label intrinsicContentSize];
    
    //------------------------------------------------------------------------------------------//
    
//    CFTimeInterval beginTimeBenckmark = CFAbsoluteTimeGetCurrent();
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text];
//
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
//    CGFloat widthConstraint = 300; // Your width constraint, using 500 as an example
//    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
//                                                                        frameSetter, /* Framesetter */
//                                                                        CFRangeMake(0, attributedString.length), /* String range (entire string) */
//                                                                        NULL, /* Frame attributes */
//                                                                        CGSizeMake(widthConstraint, CGFLOAT_MAX), /* Constraints (CGFLOAT_MAX indicates unconstrained) */
//                                                                        NULL /* Gives the range of string that fits into the constraints, doesn't matter in your situation */
//                                                                        );
//    CFRelease(frameSetter);
//    NSLog(@"\t suggestedSize: %@ | result time = %.5f",NSStringFromCGSize(suggestedSize), CFAbsoluteTimeGetCurrent() - beginTimeBenckmark);
    //
    //------------------------------------------------------------------------------------------//
    
    
    /*
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    
    [attributesDictionary setObject:[UIFont systemFontOfSize:30] forKey:NSFontAttributeName];
    [attributesDictionary setObject:[UIColor whiteColor]         forKey:NSForegroundColorAttributeName];
    [attributesDictionary setObject:[UIColor blackColor]         forKey:NSBackgroundColorAttributeName];
    [attributesDictionary setObject:@5.0                         forKey:NSBaselineOffsetAttributeName];
    [attributesDictionary setObject:@2.0                         forKey:NSStrikethroughStyleAttributeName];
    [attributesDictionary setObject:[UIColor redColor]           forKey:NSStrokeColorAttributeName];
    [attributesDictionary setObject:@2.0                         forKey:NSStrokeWidthAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0;
    [attributesDictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSShadow *shadow   = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor lightGrayColor];
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowOffset = CGSizeMake(0.0, 2.0);
    [attributesDictionary setObject:shadow forKey:NSShadowAttributeName];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text attributes:attributesDictionary];
    self.label.attributedText = attributedString;
     */
}


@end
