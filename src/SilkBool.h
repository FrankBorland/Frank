//
//  SilkBool.h
//  Frank
//
//  Created by bernhardr on 10/09/14.
//
//

#import <Foundation/Foundation.h>

@interface SilkBool : NSObject {
    @public
    NSNumber* boolValue;
}
@property NSNumber* boolValue;

- (id)initWithValue:(NSNumber*)aValue;

@end
