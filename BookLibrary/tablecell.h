//
//  tablecell.h
//  LMS
//
//  Created by Donorbadge on 2/7/13.
//  Copyright (c) 2013 Orbees. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tablecell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *lbl1;
@property(nonatomic,retain) IBOutlet UILabel *lbl2;
@property(nonatomic,retain) IBOutlet UILabel *idLabel;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *usercount;
@property(nonatomic,retain) IBOutlet UILabel *startlbl;
@property(nonatomic,retain) IBOutlet UIProgressView *proview;
@property (nonatomic,retain) IBOutlet UIButton *button;
@property (nonatomic,retain) IBOutlet UIButton *borrow;
@property (nonatomic,retain) IBOutlet UIButton *lend;
@property (nonatomic,retain) IBOutlet UIButton *ret;
@property(nonatomic, retain) IBOutlet UILabel *comlabel;
@property(nonatomic,retain) IBOutlet UILabel *titlelbl;
@property(nonatomic,retain) IBOutlet UILabel *desclbl;
@property(nonatomic,retain) IBOutlet UILabel *replycount;
@property(nonatomic,retain) IBOutlet UILabel *viewcount;
@property(nonatomic,retain) IBOutlet UIImageView *senderimg;
@property(nonatomic,retain) IBOutlet UILabel *programlbl;
@property(nonatomic,retain) IBOutlet UILabel *modulelbl;
@property(nonatomic,retain) IBOutlet UILabel *slidelbl;
@property(nonatomic,retain) IBOutlet UILabel *datelbl;
@property(nonatomic,retain) IBOutlet UILabel *percentlbl;
@property(nonatomic,retain) IBOutlet UIImageView *imgview;
@property (nonatomic,retain) IBOutlet UILabel *statuslbl;
@property (nonatomic,retain) IBOutlet UIWebView *graphview;
@property(nonatomic,retain) IBOutlet UILabel *timelbl1;
@property(nonatomic,retain) IBOutlet UILabel *timelbl2;
@property(nonatomic,retain) IBOutlet UILabel *quizlbl;
@property(nonatomic,retain) IBOutlet UILabel *scorelbl;
@property(nonatomic,retain) IBOutlet UILabel *Hrslbl;
@property(nonatomic,retain) IBOutlet UILabel *Minlbl;
@end
