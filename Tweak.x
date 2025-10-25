#import "WeChatHeaders.h"

%hook BaseMsgContentViewController
- (void)viewDidLoad {
    %orig;
    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [self.view addInteraction:dropInteraction];
}

#pragma mark - UIDropInteractionDelegate
%new
- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[UIImage class]];
}
%new
- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
}
%new
- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray *imageItems) {
    id delegate = [self m_delegate];
    if (![delegate respondsToSelector:@selector(GetMessageFromImage:)]) return;
    NSMutableArray *msgArr = [NSMutableArray array];
    for (UIImage *image in imageItems) {
    //[self pasteImage:image]; 只能发单张不够优雅
    id msg = [delegate performSelector:@selector(GetMessageFromImage:) withObject:image];
    if (msg) [msgArr addObject:msg];
    }
    if (msgArr.count == 0) return;
    SharePreConfirmSheetView *sharePreConfirmSheetView = [%c(SharePreConfirmSheetView) new];
    [sharePreConfirmSheetView setDelegate:self];
    [sharePreConfirmSheetView setTitle:@"是否发送以下图片?"];
    [sharePreConfirmSheetView setArrMsgs:msgArr];
    [sharePreConfirmSheetView setBShowTextView:NO];
    [sharePreConfirmSheetView showFromViewController:self animated:YES complete:nil];
    }];
}
%end
