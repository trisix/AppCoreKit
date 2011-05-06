//
//  CKDocumentArray.m
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-18.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKDocumentArray.h"
#import "CKNSNotificationCenter+Edition.h"

@interface CKDocumentArray()
@property (nonatomic,retain) NSMutableArray* objects;
@end

@implementation CKDocumentArray
@synthesize objects = _objects;

- (void)setObjects:(NSMutableArray*)array{
	//explicitely Make a clone
	[_objects release];
	_objects = [[NSMutableArray arrayWithArray:array]retain];
}


- (void)objectsMetaData:(CKModelObjectPropertyMetaData*)metaData{
	metaData.creatable = YES;
	
	//deepCopy + retain will make the array to duplicate all the objects from the source
	metaData.deepCopy = YES;
}

- (NSInteger)count{
	return [_objects count];
}

- (NSArray*)allObjects{
	return [NSArray arrayWithArray:_objects];
}

- (id)objectAtIndex:(NSInteger)index{
	return [_objects objectAtIndex:index];
}

- (void)insertObjects:(NSArray *)theObjects atIndexes:(NSIndexSet *)indexes{
	if([theObjects count] <= 0)
		return;
	
    //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [newItems count])];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"objects"];
    [_objects insertObjects:theObjects atIndexes:indexes];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"objects"];	
	
	[[NSNotificationCenter defaultCenter]notifyObjectsAdded:theObjects atIndexes:indexes inCollection:self];
	if(self.autosave){
		[self save];
	}
}

- (void)removeObjectsInArray:(NSArray *)otherArray{
	NSMutableArray* toRemove = [NSMutableArray array];
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
	for(id item in otherArray){
		NSUInteger index = [_objects indexOfObject:item];
		if(index == NSNotFound){
			NSLog(@"invalid object when remove");
		}
		else{
			[indexSet addIndex:index];
			[toRemove addObject:item];
		}
	}
	
	if([toRemove count] <= 0)
		return;
	
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"objects"];
	[_objects removeObjectsInArray:toRemove];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"objects"];
	
	[[NSNotificationCenter defaultCenter]notifyObjectsRemoved:toRemove atIndexes:indexSet inCollection:self];
	
	if(self.autosave){
		[self save];
	}	
}

- (void)removeAllObjects{
	NSArray* theObjects = _objects;
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[_objects count])];
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"objects"];
	[_objects removeAllObjects];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"objects"];
	
	[[NSNotificationCenter defaultCenter]notifyObjectsRemoved:theObjects atIndexes:indexSet inCollection:self];
	
	if(self.autosave){
		[self save];
	}
}

- (BOOL)containsObject:(id)object{
	return [_objects containsObject:object];
}

- (void)addObserver:(id)object{
	[self addObserver:object forKeyPath:@"objects" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)removeObserver:(id)object{
	[self removeObserver:object forKeyPath:@"objects"];
}

- (NSArray*)objectsWithPredicate:(NSPredicate*)predicate{
	return [_objects filteredArrayUsingPredicate:predicate];
}

- (void)replaceObject:(id)object byObject:(id)other{
	NSUInteger index = [_objects indexOfObject:object];
	if(index != NSNotFound){
		[self removeObjectsInArray:[NSArray arrayWithObject:object]];
		[self insertObjects:[NSArray arrayWithObject:other] atIndexes:[NSIndexSet indexSetWithIndex:index]];
		
		[[NSNotificationCenter defaultCenter]notifyObjectReplaced:object byObject:other atIndex:index inCollection:self];
	}
}

@end
