# CalculateText

 Technologies for calculating text sizes
 

| Technology     | Method                                         | Support |
|:--------------:| ---------------------------------------------- |:-------:|
| **Foundation** | `-boundingRectWithSize:options:context:`       | ✅       |
| **UIKit**      | `-sizeToFit:`                                  | ✅       |
| **CoreText**   | `CTFramesetterSuggestFrameSizeWithConstraints` | ✅       |

<br>

### Preparing data for experiments

```objectivec
NSString* text = @"This is a long sentence. Wonder how much space is needed?";
UIFont*   font = [UIFont fontWithName:@"Arial" size:17];
float    width = 300;
```

<br>

### Foundation

```objectivec
CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
CGRect frame = [text boundingRectWithSize:boundingSize
                                    options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font }
                                    context:nil];
CGSize roundedSize = CGRectIntegral(CGRectMake(0, 0, frame.size.width, frame.size.height)).size;
```

<br>

### UIKit

```objectivec
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
label.numberOfLines = 0;
label.lineBreakMode = NSLineBreakByWordWrapping;
label.font = font;
label.text = text;
[label sizeToFit];
CGSize roundedSize = CGRectIntegral(CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)).size;
```

<br>

### CoreText

```objectivec
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
```

<br>

### Additionally

Performance measurement code

```objectivec
CFTimeInterval beginTimeBenckmark = CFAbsoluteTimeGetCurrent();
// Write code which you will test here
NSLog(@"\t result time = %.5f",CFAbsoluteTimeGetCurrent() - beginTimeBenckmark);
```



<br>

#### Supporting NSAttributedString

A handy table showing the effects of attributes

https://github.com/qiuncheng/CuteAttribute

https://eezytutorials.com/ios/nsattributedstring-by-example.php

```objectivec
NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];

[attributesDictionary setObject:[UIFont systemFontOfSize:30] forKey:NSFontAttributeName];
[attributesDictionary setObject:[UIColor whiteColor]         forKey:NSForegroundColorAttributeName];
[attributesDictionary setObject:[UIColor blackColor]         forKey:NSBackgroundColorAttributeName];
[attributesDictionary setObject:@5.0                         forKey:NSBaselineOffsetAttributeName];
[attributesDictionary setObject:@2.0                         forKey:NSStrikethroughStyleAttributeName];
[attributesDictionary setObject:[UIColor redColor]           forKey:NSStrokeColorAttributeName];
[attributesDictionary setObject:@2.0                         forKey:NSStrokeWidthAttributeName];

NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
paragraphStyle.lineSpacing = 2.0;
paragraphStyle.alignment = NSTextAlignmentCenter;
[attributesDictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];

NSShadow *shadow   = [[NSShadow alloc] init];
shadow.shadowColor = [UIColor lightGrayColor];
shadow.shadowBlurRadius = 1.0;
shadow.shadowOffset = CGSizeMake(0.0, 2.0);
[attributesDictionary setObject:shadow forKey:NSShadowAttributeName];

NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text attributes:attributesDictionary];
self.label.attributedText = attributedString;

NSLog(@"%@",attributedString);
```

<br>

### Test results

From this table, we can conclude that `CoreText` is the fastest technology, but in practice this may not correspond to reality.

| Technology     | Result time |
| -------------- | ----------- |
| **Foundation** | 0.00**344** |
| **CoreText**   | 0.000**64** |
| **UIKit**      | 0.00**166** |


The following are indicators for calculating text dimensions

```objectivec
[Foundation] (lenght:19)	Size: {173, 20} 	| result time = 0.00148
[CoreText]   (lenght:19)	Size: {173, 19} 	| result time = 0.00079
[UIKit]      (lenght:19)	Size: {173, 19} 	| result time = 0.00078
------------------------------------------------------------------------
[Foundation] (lenght:57)	Size: {173, 58} 	| result time = 0.00108
[CoreText]   (lenght:57)	Size: {173, 59} 	| result time = 0.00025
[UIKit]      (lenght:57)	Size: {173, 57} 	| result time = 0.00100
------------------------------------------------------------------------
[Foundation] (lenght:65)	Size: {241, 77} 	| result time = 0.00104
[CoreText]   (lenght:65)	Size: {278, 79} 	| result time = 0.00049
[UIKit]      (lenght:65)	Size: {241, 76} 	| result time = 0.00106
------------------------------------------------------------------------
[Foundation] (lenght:32)	Size: {289, 20} 	| result time = 0.00032
[CoreText]   (lenght:32)	Size: {289, 19} 	| result time = 0.00059
[UIKit]      (lenght:32)	Size: {289, 19} 	| result time = 0.00057
------------------------------------------------------------------------
[Foundation] (lenght:21)	Size: {184, 20} 	| result time = 0.00011
[CoreText]   (lenght:21)	Size: {184, 19} 	| result time = 0.00046
[UIKit]      (lenght:21)	Size: {184, 19} 	| result time = 0.00053
------------------------------------------------------------------------
[Foundation] (lenght:36)	Size: {292, 20} 	| result time = 0.00021
[CoreText]   (lenght:36)	Size: {292, 19} 	| result time = 0.00048
[UIKit]      (lenght:36)	Size: {292, 19} 	| result time = 0.00053
------------------------------------------------------------------------
[Foundation] (lenght:6)		Size: {42, 20} 		| result time = 0.00024
[CoreText]   (lenght:6)		Size: {42, 19} 		| result time = 0.00040
[UIKit]      (lenght:6)		Size: {42, 19} 		| result time = 0.00050
------------------------------------------------------------------------
[Foundation] (lenght:4)		Size: {28, 20} 		| result time = 0.00006
[CoreText]   (lenght:4)		Size: {28, 19} 		| result time = 0.00013
[UIKit]      (lenght:4)		Size: {28, 19} 		| result time = 0.00033
------------------------------------------------------------------------
[Foundation] (lenght:153)	Size: {296, 172} 	| result time = 0.00151
[CoreText]   (lenght:153)	Size: {292, 179} 	| result time = 0.00052
[UIKit]      (lenght:153)	Size: {296, 171} 	| result time = 0.00187
------------------------------------------------------------------------
[Foundation] (lenght:14)	Size: {125, 20} 	| result time = 0.00015
[CoreText]   (lenght:14)	Size: {125, 19} 	| result time = 0.00020
[UIKit]      (lenght:14)	Size: {125, 19} 	| result time = 0.00060
------------------------------------------------------------------------
[Foundation] (lenght:397)	Size: {300, 305} 	| result time = 0.00154
[CoreText]   (lenght:397)	Size: {298, 319} 	| result time = 0.00092
[UIKit]      (lenght:397)	Size: {300, 304} 	| result time = 0.00197
------------------------------------------------------------------------
[Foundation] (lenght:181)	Size: {294, 191} 	| result time = 0.00116
[CoreText]   (lenght:181)	Size: {289, 199} 	| result time = 0.00053
[UIKit]      (lenght:181)	Size: {294, 190} 	| result time = 0.00137
------------------------------------------------------------------------
[Foundation] (lenght:175)	Size: {257, 191} 	| result time = 0.00104
[CoreText]   (lenght:175)	Size: {253, 199} 	| result time = 0.00050
[UIKit]      (lenght:175)	Size: {257, 190} 	| result time = 0.00129
------------------------------------------------------------------------
[Foundation] (lenght:170)	Size: {257, 172} 	| result time = 0.00076
[CoreText]   (lenght:170)	Size: {283, 179} 	| result time = 0.00039
[UIKit]      (lenght:170)	Size: {257, 171} 	| result time = 0.00127
------------------------------------------------------------------------
[Foundation] (lenght:100)	Size: {298, 77} 	| result time = 0.00078
[CoreText]   (lenght:100)	Size: {293, 79} 	| result time = 0.00038
[UIKit]      (lenght:100)	Size: {298, 76} 	| result time = 0.00088
------------------------------------------------------------------------
[Foundation] (lenght:83)	Size: {281, 115} 	| result time = 0.00103
[CoreText]   (lenght:83)	Size: {276, 119} 	| result time = 0.00034
[UIKit]      (lenght:83)	Size: {281, 114} 	| result time = 0.00128
------------------------------------------------------------------------
[Foundation] (lenght:5)  	Size: {24, 16} 	    | result time = 0.00024
[CoreText]   (lenght:5)  	Size: {24, 15} 	    | result time = 0.00022
[UIKit]      (lenght:5)  	Size: {24, 15} 	    | result time = 0.00056
------------------------------------------------------------------------
[Foundation] (lenght:6)  	Size: {39, 16} 	    | result time = 0.00007
[CoreText]   (lenght:6)  	Size: {39, 15} 	    | result time = 0.00017
[UIKit]      (lenght:6)  	Size: {39, 15} 	    | result time = 0.00033
------------------------------------------------------------------------
[Foundation] (lenght:7)  	Size: {40, 16} 	    | result time = 0.00006
[CoreText]   (lenght:7)  	Size: {40, 15} 	    | result time = 0.00024
[UIKit]      (lenght:7)  	Size: {40, 15} 	    | result time = 0.00048
------------------------------------------------------------------------
[Foundation] (lenght:6)  	Size: {40, 16} 	    | result time = 0.00007
[CoreText]   (lenght:6)  	Size: {40, 15} 	    | result time = 0.00015
[UIKit]      (lenght:6)  	Size: {40, 15} 	    | result time = 0.00031
------------------------------------------------------------------------
[Foundation] (lenght:9)  	Size: {52, 16} 	    | result time = 0.00005
[CoreText]   (lenght:9)  	Size: {52, 15} 	    | result time = 0.00013
[UIKit]      (lenght:9)  	Size: {52, 15} 	    | result time = 0.00042
------------------------------------------------------------------------
[Foundation] (lenght:6)  	Size: {40, 16} 	    | result time = 0.00005
[CoreText]   (lenght:6)  	Size: {40, 15} 	    | result time = 0.00017
[UIKit]      (lenght:6)  	Size: {40, 15} 	    | result time = 0.00075
------------------------------------------------------------------------
[Foundation] (lenght:6)  	Size: {38, 16} 	    | result time = 0.00008
[CoreText]   (lenght:6)  	Size: {38, 15} 	    | result time = 0.00018
[UIKit]      (lenght:6)  	Size: {38, 15} 	    | result time = 0.00053
------------------------------------------------------------------------
```

<br><br>

### Useful material

[Как написать отличную ленту новостей ВКонтакте за 20 часов / Хабр](https://habr.com/ru/post/432356/)

[Сложные отображения коллекций в iOS: проблемы и решения на примере ленты ВКонтакте / Блог компании ВКонтакте / Хабр](https://habr.com/ru/company/vk/blog/481626/)
