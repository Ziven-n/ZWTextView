//
//  MGTextView.m
//  CheDaiBao
//
//  Created by zzw on 17/3/13.
//  Copyright © 2017年 MG. All rights reserved.
//

#import "ZWTextView.h"

@interface ZWTextView()<UITextViewDelegate>

/**
 占位textview
 */
@property (nonatomic, strong) UITextView *placeholderView;

/**
 最大高度
 */
@property (nonatomic, assign) NSInteger maxHeight;

/**
 移动类型
 */
@property (nonatomic, assign) MyTextViewStyle  myStyle;

/**
 初始高度
 */
@property (nonatomic, assign) NSInteger defaultHeight;

/**
 初始Y坐标
 */
@property (nonatomic, assign) CGFloat defaultY;

/**
 传入的高度
 */
@property (nonatomic, assign) CGFloat beginHeight;

/**
 偏移高度
 */
@property (nonatomic, assign) CGFloat offsetHeight;

@end

@implementation ZWTextView

- (instancetype)initWithFrame:(CGRect)frame TextFont:(UIFont *)font MoveStyle:(MyTextViewStyle)style {
    
    self = [super initWithFrame:frame];
    
    self.font = font;

    _myStyle = style;
    
    _defaultY = frame.origin.y;
    
    _beginHeight = frame.size.height;
    
    [self configUI];
    
    return self;
}


- (void)configUI {
    
    //使用placeholderView可以拿到准确高度再设置self的高度，使用self高度会有偏差
    NSInteger height = ceilf([self.placeholderView sizeThatFits:CGSizeMake(self.bounds.size.width, self.bounds.size.height)].height);
    
    self.defaultHeight = height;
    
    //处理高度偏移问题
    _offsetHeight = (_beginHeight - _defaultHeight)/2;
    
    NSLog(@"传入的高度%f,实际高度%ld,父视图高度%f",_beginHeight,_defaultHeight,self.superview.frame.size.height);
    
    //设置初始高度
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+_offsetHeight, self.frame.size.width, height);
    self.layer.cornerRadius = 2;
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.returnKeyType = UIReturnKeyDone;
    self.delegate = self;
    self.enablesReturnKeyAutomatically = NO;        //设置没输入内容时也可以点击确定按钮
    
    //实时监听textView值的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    //设置上下边距
    self.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);     //系统会为其默认设置距UITextView上、下边缘各8的页边距
    self.textContainer.lineFragmentPadding = 0;     //textContainer中的文段的上、下、左、右又会被填充5的空白

}

- (void)textDidChange {
    
    //如果用户没有设置则默认为5
    if (!_maxNumberOfLines) {
        //最大高度
        _maxHeight = ceil(self.font.lineHeight * 5  + self.textContainerInset.top + self.textContainerInset.bottom);
    }
    
    // 根据文字内容决定placeholderView是否隐藏
    self.placeholderView.hidden = self.text.length > 0;
    
    //textView的高度
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, self.bounds.size.height)].height);
    
    //上
    if (self.myStyle&1<<1) {
        
        //如果文本高度大于了设置的最大高度，则textview的高度不再变化
        if (height >= _maxHeight) {
            self.frame = CGRectMake(self.frame.origin.x, _defaultY+_offsetHeight-(_maxHeight-_defaultHeight), self.frame.size.width, _maxHeight);
            self.scrollEnabled = YES;
        }else {
            self.frame = CGRectMake(self.frame.origin.x, _defaultY+_offsetHeight-(height-_defaultHeight), self.frame.size.width, height);
            
//            NSLog(@"初始高度%ld---目前高度%ld",_defaultHeight,height);
            self.scrollEnabled = NO;
        }
    }
    //下
    if (self.myStyle&1<<2) {
        
        //如果文本高度大于了设置的最大高度，则textview的高度不再变化
        if (height >= _maxHeight) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _maxHeight);
            self.scrollEnabled = YES;
        }else {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
            self.scrollEnabled = NO;
        }
    }
    //中心
    if (self.myStyle&1<<3) {
        
        //如果文本高度大于了设置的最大高度，则textview的高度不再变化
        if (height >= _maxHeight) {
            self.frame = CGRectMake(self.frame.origin.x, _defaultY+_offsetHeight-(_maxHeight-_defaultHeight)/2, self.frame.size.width, _maxHeight);
            self.scrollEnabled = YES;
        }else {
            self.frame = CGRectMake(self.frame.origin.x, _defaultY+_offsetHeight-(height-_defaultHeight)/2, self.frame.size.width, height);
            
//            NSLog(@"初始高度%ld---目前高度%ld",_defaultHeight,height);
            self.scrollEnabled = NO;
        }
    }
    
//    NSLog(@"高度%ld",height);
}

- (UITextView *)placeholderView {
    
    if (!_placeholderView ) {
        UITextView *placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font =  self.font;
        _placeholderView.textColor = [UIColor colorWithRed:(188)/255.0f green:(188)/255.0f blue:(194)/255.0f alpha:(1)];
        _placeholderView.backgroundColor = [UIColor clearColor];
        _placeholderView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);     //系统会为其默认设置距UITextView上、下边缘各8的页边距
        _placeholderView.textContainer.lineFragmentPadding = 0;     //textContainer中的文段的上、下、左、右又会被填充5的空白
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}

- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    
    _maxNumberOfLines = maxNumberOfLines;
    //最大高度
    _maxHeight = ceil(self.font.lineHeight * maxNumberOfLines  + self.textContainerInset.top + self.textContainerInset.bottom);
}

#pragma mark -- UITextViewDelegate --

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        [self resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
