//
// RMFSMapSource.h
//

#import "RMAbstractMercatorTileSource.h"
#import "RMProjection.h"

@interface RMFSMapSource : RMAbstractMercatorTileSource

- (id)initWithPath:(NSString *)path;

- (CLLocationCoordinate2D)topLeftOfCoverage;
- (CLLocationCoordinate2D)bottomRightOfCoverage;
- (CLLocationCoordinate2D)centerOfCoverage;

@end
