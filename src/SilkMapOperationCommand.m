//
//  SilkMapOperationCommand.m
//  Frank
//
//  Created by bernhardr on 9/10/2014.
//

#import "SilkMapOperationCommand.h"

#import "FranklyProtocolHelper.h"

#import "ViewJSONSerializer.h"
#import "JSON.h"

#import "SelectorEngineRegistry.h"

#import "Operation.h"

#if TARGET_OS_IPHONE
#define FrankMapViewType UIView
#else
#define FrankMapViewType NSView
#endif


@implementation SilkMapOperationCommand

- (id) performOperation:(Operation *)operation onView:(FrankMapViewType *)view {
    
	if( [operation appliesToObject:view] )
		return [operation applyToObject:view];
    
	[NSException raise:@"Error executing map command" format:@"method does not exist"];
    return nil;
}

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
	NSDictionary *requestCommand = FROM_JSON(requestBody);
    
	NSString *selectorEngineString = [requestCommand objectForKey:@"selector_engine"];
    if( !selectorEngineString )
        selectorEngineString = @"uiquery"; // default to UIQuery, for compatibility with old clients
    
	NSString *selector = [requestCommand objectForKey:@"query"];
	NSDictionary *operationDict = [requestCommand objectForKey:@"operation"];
	Operation *operation = [[[Operation alloc] initFromJsonRepresentation:operationDict] autorelease];
    
    NSArray *viewsToMap = nil;
    @try {
        viewsToMap = [SelectorEngineRegistry selectViewsWithEngineNamed:selectorEngineString usingSelector:selector];
    }
    @catch (NSException * e) {
		NSLog( @"Exception while using %@ to select views with '%@':\n%@", selectorEngineString, selector, e );
		return [FranklyProtocolHelper generateErrorResponseWithReason:@"invalid selector" andDetails:[e reason]];
	}
	
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[viewsToMap count]];
	for (FrankMapViewType *view in viewsToMap) {
		@try {
			id result = [self performOperation:operation onView:view];
			[results addObject:[ViewJSONSerializer silkjsonify:result]];
		}
		@catch (NSException * e) {
			NSLog( @"Exception while performing operation %@\n%@", operation, e );
			return [FranklyProtocolHelper generateErrorResponseWithReason: [ NSString stringWithFormat:@"encountered error while attempting to perform %@ on selected elements",operation]
                                                               andDetails:[e reason]];
		}
	}
    
    return [FranklyProtocolHelper generateSuccessResponseWithResults: results];
}

@end
