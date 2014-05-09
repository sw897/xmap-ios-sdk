//
// RMFSMapSource.h
//

#import "RMAbstractMercatorTileSource.h"
#import "RMProjection.h"

@interface RMFSMapSource : RMAbstractMercatorTileSource <NSXMLParserDelegate>


@property int  relWidth;

@property int  relHeight;

@property int  relNumber;

@property int  worldSize;

- (id)initWithPath:(NSString *)path minZoom:(float)minZoom maxZoom:(float)maxZoom;

- (NSString*)folderName:(RMTile)tile;

@end
