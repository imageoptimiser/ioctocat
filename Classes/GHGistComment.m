#import "GHGistComment.h"
#import "GHGist.h"
#import "iOctocat.h"
#import "NSDictionary+Extensions.h"


@interface GHGistComment ()
@property(nonatomic,weak)GHGist *gist;
@end


@implementation GHGistComment

- (id)initWithGist:(GHGist *)gist andDictionary:(NSDictionary *)dict {
	self = [self initWithGist:gist];
	if (self) {
		[self setUserWithValues:[dict safeDictForKey:@"user"]];
		self.body = [dict safeStringForKey:@"body"];
		self.created = [iOctocat parseDate:[dict safeStringForKey:@"created_at"]];
		self.updated = [iOctocat parseDate:[dict safeStringForKey:@"updated_at"]];
	}
	return self;
}

- (id)initWithGist:(GHGist *)gist {
	self = [super init];
	if (self) {
		self.gist = gist;
	}
	return self;
}

#pragma mark Saving

- (void)saveData {
	NSDictionary *values = @{@"body": self.body};
	NSString *path = [NSString stringWithFormat:kGistCommentsFormat, self.gist.gistId];
	[self saveValues:values withPath:path andMethod:kRequestMethodPost useResult:nil];
}

@end