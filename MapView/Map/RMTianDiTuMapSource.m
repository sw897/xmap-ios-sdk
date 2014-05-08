//
//  RMTianDiTuMapSource.m
//  MapView
//
//  Created by sw on 14-5-8.
//
//

#import "RMTianDiTuMapSource.h"

@implementation RMTianDiTuMapSource
{
    NSString *_host;
}

- (id)initWithHost:(NSString *)host
{
    if (!(self = [super init]))
        return nil;
    
    NSAssert(host != nil, @"Empty host parameter not allowed");
    
    _host = host;
    
    self.minZoom = 0;
    self.maxZoom = 18;
    
    self.opaque = NO;
    return self;
}

- (NSArray *)URLsForTile:(RMTile)tile
{
	NSAssert4(((tile.zoom >= self.minZoom) && (tile.zoom <= self.maxZoom)),
			  @"%@ tried to retrieve tile with zoomLevel %d, outside source's defined range %f to %f",
			  self, tile.zoom, self.minZoom, self.maxZoom);
    
	return [NSArray arrayWithObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@&service=wmts&request=GetTile&version=1.0.0&tileMatrixSet=w&style=default&format=tiles&TileMatrix=%d&&TileRow=%d&TileCol=%d", _host, tile.zoom, tile.y, tile.x]]];
}

- (NSString *)uniqueTilecacheKey
{
	return [NSString stringWithFormat:@"TianDiTuMapLayer%@", _host];
}

- (NSString *)shortName
{
	return @"TianDiTuMapLayer";
}

- (NSString *)longDescription
{
	return @"天地图";
}

- (NSString *)shortAttribution
{
	return @"© 天地图";
}

- (NSString *)longAttribution
{
	return @"Map data © 天地图.";
}

@end