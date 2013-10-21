//
//  tablecell.m
//  LMS
//
//  Created by Donorbadge on 2/7/13.
//  Copyright (c) 2013 Orbees. All rights reserved.
//

#import "tablecell.h"

@implementation tablecell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
