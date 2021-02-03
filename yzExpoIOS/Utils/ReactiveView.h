//
//  ReactiveView.h
//  ImoocHybridIOSNative
//
//  Created by 王思远 on 2020/12/26.
//  Copyright © 2020 LGD_Sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReactiveView <NSObject>

@optional

- (void)bindViewModel:(id)viewModel;


- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;

@end
