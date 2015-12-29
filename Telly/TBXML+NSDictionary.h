//
//  TBXML+NSDictionary.h
//  Telly
//
//  Created by Gio Salinas on 30-06-15.
//  Copyright (c) 2015 Gio Salinas. All rights reserved.
//

#import <TBXML/TBXML.h>

@interface TBXML (TBXML_NSDictionary)
+ (NSDictionary*)dictionaryFromNode:(TBXMLElement*)element;
+ (NSDictionary*)xmlToDictionary:(NSData*)data;
@end
