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

#pragma mark -

@implementation RMFSMapSource
{
    NSString *_uniqueTilecacheKey;
    NSUInteger _tileSideLength;
    NSString *_path;
}

@synthesize relWidth;
@synthesize relHeight;
@synthesize relNumber;

- (id)initWithPath:(NSString *)path minZoom:(float)minZoom maxZoom:(float)maxZoom
{
    if (!(self = [super init]))
        return nil;
    
    _path = path;
    self.minZoom = minZoom;
    self.maxZoom = maxZoom;

    _uniqueTilecacheKey = [[path lastPathComponent] stringByDeletingPathExtension];
    
    // read parameters from ImageProperties.xml
    NSString *config = [NSString stringWithFormat:@"%@/ImageProperties.xml", _path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:config])
    {
        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:config];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",dataString);
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        [xmlParser setDelegate:self];
        [xmlParser setShouldProcessNamespaces:NO];
        [xmlParser setShouldReportNamespacePrefixes:NO];
        [xmlParser setShouldResolveExternalEntities:NO];
        [xmlParser parse];
    }
    return self;
}

- (NSString*)folderName:(RMTile)tile
{
    double pos = 0;
    int num = 0;
    int worldsize = _tileSideLength*pow(2, self.maxZoom);
    for (int i = 0; i<tile.zoom; i++) {
        num = pow(2, i);
        pos += ceil(relWidth*num/worldsize)*ceil(relHeight*num/worldsize);
    }
    num = pow(2, tile.zoom);
    pos += tile.y * ceil(relWidth*num/worldsize);
    pos += tile.x;
    //fixed 0-0-0.jpg
    pos += 0.1;
    int val = (int)(ceil(pos/_tileSideLength) - 1);
    return [NSString stringWithFormat:@"TileGroup%d", val];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"IMAGE_PROPERTIES"]) {
        relWidth = [[attributeDict objectForKey:@"WIDTH"] integerValue];
        relHeight = [[attributeDict objectForKey:@"HEIGHT"] integerValue];
        relNumber = [[attributeDict objectForKey:@"NUMTILES"] integerValue];
        _tileSideLength = [[attributeDict objectForKey:@"TILESIZE"] integerValue];
    }
}

#pragma mark RMTileSource methods

- (UIImage *)imageForTile:(RMTile)tile inCache:(RMTileCache *)tileCache
{
    __block UIImage *image = nil;
    
	tile = [[self mercatorToTileProjection] normaliseTile:tile];
    
    if (self.isCacheable)
    {
        image = [tileCache cachedImage:tile withCacheKey:[self uniqueTilecacheKey]];
        
        if (image)
            return image;
    }
    
    // read image from file
    NSString *imgname = [NSString stringWithFormat:@"%d-%d-%d.jpg", tile.zoom, tile.x, tile.y];
    NSString *imgfile=[NSString stringWithFormat:@"%@/%@/%@", _path, [self folderName:tile], imgname];
    
    NSLog(@"%@", imgfile);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgfile])
    {
        image = [[UIImage alloc] initWithContentsOfFile:imgfile];
        CGSize size = image.size;
        // copy image
        if (size.height < _tileSideLength || size.width < _tileSideLength) {
            CGSize finalSize;
            finalSize.width = _tileSideLength;
            finalSize.height = _tileSideLength;
            UIGraphicsBeginImageContext(finalSize);
            [image drawInRect:CGRectMake(0,0,size.width,size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    else
        image = [RMTileImage missingTile];
    

    if (image && self.isCacheable)
        [tileCache addImage:image forTile:tile withCacheKey:[self uniqueTilecacheKey]];
    
	return image;
}


- (NSUInteger)tileSideLength
{
    return _tileSideLength;
}

- (NSString *)uniqueTilecacheKey
{
    return _uniqueTilecacheKey;
}

- (NSString *)shortName
{
	return @"FSMapSource";
}

- (NSString *)longDescription
{
	return @"FileSystemMapSource";
}

- (NSString *)shortAttribution
{
	return @"kaka";
}

- (NSString *)longAttribution
{
	return @"kak";
}

#pragma mark preference methods

@end
