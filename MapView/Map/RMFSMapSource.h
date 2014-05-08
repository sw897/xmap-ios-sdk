//
// RMFSMapSource.h
//

#import "RMAbstractMercatorTileSource.h"
#import "RMProjection.h"

@interface RMFSMapSource : RMAbstractMercatorTileSource <NSXMLParserDelegate>


@property int  relWidth;

@property int  relHeight;

@property int  relNumber;

- (id)initWithPath:(NSString *)path minZoom:(float)minZoom maxZoom:(float)maxZoom;

- (NSString*)folderName:(RMTile)tile;

@end
