@interface NSString()
- (NSString *)_web_stringByTrimmingWhitespace;
@end

@interface UIApplication()
- (void)applicationOpenURL:(id)url;
@end

@interface SearchQueryBuilder : NSObject
+ (id)searchQueryBuilderWithQuery:(id)query;
- (id)searchURL;
@end

@interface BrowserController : NSObject
+ (id)sharedBrowserController;
- (void)addRecentSearch:(id)query;
- (id)loadURLInNewWindow:(id)newWindow inBackground:(BOOL)background animated:(BOOL)animated;
- (void)loadURLInNewWindow:(id)newWindow animated:(BOOL)animated;
@end

@interface RecentWebSearchesController : NSObject
+ (id)sharedController;
- (void)addRecentSearch:(NSString *)text;
@end

%hook BrowserController
static void Search(NSString *search)
{
    BrowserController *self = [%c(BrowserController) sharedBrowserController];
    NSString *query = [search _web_stringByTrimmingWhitespace];
    SearchQueryBuilder *builder = [%c(SearchQueryBuilder) searchQueryBuilderWithQuery:query];
    NSURL *searchURL = [builder searchURL];
    if ([self respondsToSelector:@selector(addRecentSearch:)]) {
        // iOS -7
        [self addRecentSearch:query];
    } else {
        // iOS 8+
        RecentWebSearchesController *recentController = [%c(RecentWebSearchesController) sharedController];
        [recentController addRecentSearch:query];
    }
    if ([self respondsToSelector:@selector(loadURLInNewWindow:inBackground:animated:)])
        [self loadURLInNewWindow:searchURL inBackground:NO animated:NO];
    else
        [self loadURLInNewWindow:searchURL animated:NO];
}
// iOS 4-7
- (void)_doSearch:(NSString *)search
{
    Search(search);
}
// iOS 8+
- (void)doSearch:(NSString *)search
{
    Search(search);
}
%end
