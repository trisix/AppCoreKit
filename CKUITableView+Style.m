//
//  CKUITableView+Style.m
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-21.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKUITableView+Style.h"
#import "CKStyles.h"
#import "CKStyleManager.h"
#import "CKStyle+Parsing.h"

NSString* CKTableViewStyle = @"tableViewStyle";

@implementation NSMutableDictionary (CKUITableViewStyleStyle)

- (UITableViewStyle)tableViewStyle{
	return (UITableViewStyle)[self enumValueForKey:CKStyleCellType 
										withDictionary:CKEnumDictionary( UITableViewStylePlain,
																		UITableViewStyleGrouped  )];
}

@end

@implementation UITableView (CKStyle)

+ (BOOL)applyStyle:(NSMutableDictionary*)style toView:(UIView*)view propertyName:(NSString*)propertyName appliedStack:(NSMutableSet*)appliedStack delegate:(id)delegate{
	UITableView* tableView = (UITableView*)view;
	/*
	 //TO SET IF POSSIBLE ...
	 if([style containsObjectForKey:CKTableViewStyle]){
		tableView.style = [style tableViewStyle];
	}*/
	
	//NSMutableDictionary* myViewStyle = [style styleForObject:tableView propertyName:propertyName];
	//tableView.backgroundView = [[[UIView alloc]initWithFrame:view.bounds]autorelease];
	//tableView.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[UIView applyStyle:myViewStyle toView:tableView.backgroundView propertyName:@"backgroundView" appliedStack:appliedStack];
	if([UIView applyStyle:style toView:view propertyName:propertyName appliedStack:appliedStack delegate:delegate]){
		return YES;
	}
	return NO;
}

@end