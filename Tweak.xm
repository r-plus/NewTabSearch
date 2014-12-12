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
- (void)addRecentSearch:(id)query;
- (id)loadURLInNewWindow:(id)newWindow inBackground:(BOOL)background animated:(BOOL)animated;
- (void)loadURLInNewWindow:(id)newWindow animated:(BOOL)animated;
@end

%hook BrowserController
- (void)_doSearch:(id)search
{
    NSString *query = [search _web_stringByTrimmingWhitespace];
    SearchQueryBuilder *builder = [%c(SearchQueryBuilder) searchQueryBuilderWithQuery:query];
    NSURL *searchURL = [builder searchURL];
    [self addRecentSearch:query];
    if ([self respondsToSelector:@selector(loadURLInNewWindow:inBackground:animated:)])
        [self loadURLInNewWindow:searchURL inBackground:NO animated:NO];
    else
        [self loadURLInNewWindow:searchURL animated:NO];
}
%end
