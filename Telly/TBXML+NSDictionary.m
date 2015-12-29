//
//  TBXML+NSDictionary.m
//  Telly
//
//  Created by Gio Salinas on 30-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import "TBXML+NSDictionary.h"

@implementation TBXML (TBXML_NSDictionary)

+ (NSDictionary*)dictionaryFromNode:(TBXMLElement*)element
{
    NSMutableDictionary *elementDict = [[NSMutableDictionary alloc] init];
    
    TBXMLAttribute *attribute = element->firstAttribute;
    while (attribute)
    {
        [elementDict setObject:[TBXML attributeValue:attribute] forKey:[TBXML attributeName:attribute]];
        attribute = attribute->next;
    }
    
    TBXMLElement *childElement = element->firstChild;
    if (childElement) {
        
        while (childElement) {
            
            if ([elementDict objectForKey:[TBXML elementName:childElement]] == nil) {
                
                [elementDict addEntriesFromDictionary:[self dictionaryFromNode:childElement]];
                
            } else if ([[elementDict objectForKey:[TBXML elementName:childElement]] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self dictionaryFromNode:childElement] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setObject:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                items = nil;
                
            } else {
                
                NSMutableArray *items = [[NSMutableArray alloc] init];
                [items addObject:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self dictionaryFromNode:childElement] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setObject:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                items = nil;
            }
            
            childElement = childElement->nextSibling;
        }
        
    } else if ([TBXML textForElement:element] != nil && [TBXML textForElement:element].length>0) {
        
        if ([elementDict count]>0) {
            [elementDict setObject:[TBXML textForElement:element] forKey:@"text"];
        } else {
            [elementDict setObject:[TBXML textForElement:element] forKey:[TBXML elementName:element]];
        }
    }
    
    
    NSDictionary *resultDict = nil;
    
    if ([elementDict count]>0) {
        
        if ([elementDict valueForKey:[TBXML elementName:element]] == nil) {
            resultDict = [NSDictionary dictionaryWithObject:elementDict forKey:[TBXML elementName:element]];
        } else {
            resultDict = [NSDictionary dictionaryWithDictionary:elementDict];
        }
    }
    
    elementDict = nil;
    
    return resultDict;
}


+ (NSDictionary*)xmlToDictionary:(NSData*)data
{
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data error:nil];
    
    NSAssert(tbxml.rootXMLElement, @"no root :(");
    
    return [self dictionaryFromNode:tbxml.rootXMLElement];
}
@end