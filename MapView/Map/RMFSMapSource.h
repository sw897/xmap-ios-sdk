//
// RMFSMapSource.h
//

#import "RMAbstractMercatorTileSource.h"
#import "RMProjection.h"

@interface RMFSMapSource : RMAbstractMercatorTileSource <NSXMLParserDelegate>


@property int  relWidth;

@property int  relHeight;

@property int  relNumber;

- (id)initWithPath:(NSString *)path;

- (NSString*)folderName:(RMTile)tile;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

@end
