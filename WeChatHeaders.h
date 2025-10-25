#import <UIKit/UIKit.h>

@protocol SharePreConfirmSheetViewDelegate <NSObject>
@end

@interface BaseMsgContentViewController : UIViewController <SharePreConfirmSheetViewDelegate, UIDropInteractionDelegate>
@property (nonatomic, readwrite) id m_delegate;
//- (void)pasteImage:(id)image; //原始的输入框粘贴图片接口
@end

@interface SharePreConfirmSheetView : UIView
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSArray *arrMsgs;
@property (nonatomic) BOOL bShowTextView;
@property (weak, nonatomic) id <SharePreConfirmSheetViewDelegate> delegate;
- (void)showFromViewController:(id)controller animated:(BOOL)animated complete:(id /* block */)complete;
@end
