//
//  Annotation.m
//  TWI
//
//  Created by Saitejaswi Kondapalli on 1/16/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (id) initWithTitle:(NSString *) newTitle Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    
    if (self)
    {
        _title = newTitle;
        _coordinate = location;
    }
    
    return self;
}

- (MKAnnotationView *) annotationView
{
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Annotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"bottle16.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
