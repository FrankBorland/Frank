//
//  SilkBool.m
//  Frank
//
//  Created by bernhardr on 10/09/14.
//
//

#import "SilkBool.h"

@implementation SilkBool
@synthesize boolValue;

- (id)initWithValue:(NSNumber*)aValue
{
    if( self = [super init] )
    {
        boolValue = aValue;
    }
    
    return self;
}

@end
