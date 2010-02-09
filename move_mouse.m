#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <HIToolbox/CarbonEvents.h>
#include <stdio.h>

void move_mouse(int x, int y);
void register_hotkey(void);
OSStatus hotkey_handler(EventHandlerCallRef next_handler, EventRef event, void *user_data);

int x, y;

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSUserDefaults *args = [NSUserDefaults standardUserDefaults];

  x = [args integerForKey:@"x"];
  y = [args integerForKey:@"y"];

  // move_mouse(x, y);
  register_hotkey();

  // NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
  // while (true && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

  SetMouseCoalescingEnabled(false, NULL);
  CGSetLocalEventsSuppressionInterval(0.0001);
  
  RunApplicationEventLoop();

  [pool release];
  return 0;
}

void register_hotkey() {
  EventHotKeyRef hotkey;
  EventHotKeyID  hotkey_id;
  EventTypeSpec  event_type;

  event_type.eventKind   = kEventHotKeyPressed;
  event_type.eventClass  = kEventClassKeyboard;
  hotkey_id.signature    = 'htk1';
  hotkey_id.id           = 1;

  RegisterEventHotKey(49, optionKey, hotkey_id, GetApplicationEventTarget(), 0, &hotkey);
  InstallApplicationEventHandler(&hotkey_handler, 1, &event_type, NULL, NULL);
}

OSStatus hotkey_handler(EventHandlerCallRef next_handler, EventRef event, void *user_data) {
  int i;

  CGEventRef ev  = CGEventCreate(NULL);
  CGPoint cur_pt = CGEventGetLocation(ev);
  NSLog(@"Location: %f, %f", (float)cur_pt.x, (float)cur_pt.y);

  for (i = 0; i < 5; i++)
    move_mouse(x + i, y);

  return noErr;
}

void move_mouse(int x, int y) {
  NSLog(@"moving to %d, %d", x, y);
  CGPoint pt;
  pt.x = x;
  pt.y = y;
  CGWarpMouseCursorPosition(pt);
}
