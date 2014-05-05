//
// RMFSMapSource.m
//
// RMFSMap source is an implementation of an file system tile source which is
// can be used as an offline map store. 
//
// The implementation expects two parts:
//
// file "preferences" - contains the map meta data as name/value pairs
//
//    The preferences must at least contain the following
//    values for the tile source to function properly.
//
//      * map.minZoom           - minimum supported zoom level
//      * map.maxZoom           - maximum supported zoom level
//      * map.tileSideLength    - tile size in pixels
//
//    Optionally it can contain the following values
//
//    Coverage area:
//      * map.coverage.topLeft.latitude
//      * map.coverage.topLeft.longitude
//      * map.coverage.bottomRight.latitude
//      * map.coverage.bottomRight.longitude
//      * map.coverage.center.latitude
//      * map.coverage.center.longitude
//
//    Attribution:
//      * map.shortName
//      * map.shortAttribution
//      * map.longDescription
//      * map.longAttribution
//

#import "RMFSMapSource.h"
#import "RMTileImage.h"
#import "RMTileCache.h"
#import "RMFractalTileProjection.h"

#pragma mark --- begin constants ----

// mandatory preference keys
#define kMinZoomKey @"map.minZoom"
#define kMaxZoomKey @"map.maxZoom"
#define kTileSideLengthKey @"map.tileSideLength"

// optional preference keys for the coverage area
#define kCoverageTopLeftLatitudeKey @"map.coverage.topLeft.latitude"
#define kCoverageTopLeftLongitudeKey @"map.coverage.topLeft.longitude"
#define kCoverageBottomRightLatitudeKey @"map.coverage.bottomRight.latitude"
#define kCoverageBottomRightLongitudeKey @"map.coverage.bottomRight.longitude"
#define kCoverageCenterLatitudeKey @"map.coverage.center.latitude"
#define kCoverageCenterLongitudeKey @"map.coverage.center.longitude"

// optional preference keys for the attribution
#define kShortNameKey @"map.shortName"
#define kLongDescriptionKey @"map.longDescription"
#define kShortAttributionKey @"map.shortAttribution"
#define kLongAttributionKey @"map.longAttribution"

#pragma mark --- end constants ----

@interface RMFSMapSource (Preferences)

- (NSString *)getPreferenceAsString:(NSString *)name;
- (float)getPreferenceAsFloat:(NSString *)name;
- (int)getPreferenceAsInt:(NSString *)name;

@end

#pragma mark -

@implementation RMFSMapSource
{
    // coverage area
    CLLocationCoordinate2D _topLeft;
    CLLocationCoordinate2D _bottomRight;
    CLLocationCoordinate2D _center;
    
    NSString *_uniqueTilecacheKey;
    NSUInteger _tileSideLength;
    
}

- (id)initWithPath:(NSString *)path
{
    if (!(self = [super init]))
        return nil;
    
    _uniqueTilecacheKey = [[path lastPathComponent] stringByDeletingPathExtension];

}

#pragma mark RMTileSource methods

- (UIImage *)imageForTile:(RMTile)tile inCache:(RMTileCache *)tileCache
{
    	return nil;
}

- (NSString *)shortName
{
	return [self getPreferenceAsString:kShortNameKey];
}

- (NSString *)longDescription
{
	return [self getPreferenceAsString:kLongDescriptionKey];
}

- (NSString *)shortAttribution
{
	return [self getPreferenceAsString:kShortAttributionKey];
}

- (NSString *)longAttribution
{
	return [self getPreferenceAsString:kLongAttributionKey];
}

#pragma mark preference methods

- (float)getPreferenceAsFloat:(NSString *)name
{
	NSString *value = [self getPreferenceAsString:name];
	return (value == nil) ? INT_MIN : [value floatValue];
}

- (int)getPreferenceAsInt:(NSString *)name
{
	NSString* value = [self getPreferenceAsString:name];
	return (value == nil) ? INT_MIN : [value intValue];
}

@end
