//
//  Annotation.h
//  TWI
//
//  Created by Saitejaswi Kondapalli on 1/16/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

- (id) initWithTitle:(NSString *) newTitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *) annotationView;
@end
