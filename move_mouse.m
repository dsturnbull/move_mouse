#import <Foundation/Foundation.h>
#import <HIToolbox/CarbonEvents.h>
#include <stdio.h>

void register_hotkey(void);
OSStatus hotkey_handler(EventHandlerCallRef next_handler, EventRef event, void *user_data);

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // NSUserDefaults *args = [NSUserDefaults standardUserDefaults];

  register_hotkey();

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

  hotkey_id.signature    = 'left';
  hotkey_id.id           = 0;
  RegisterEventHotKey(123, cmdKey + shiftKey, hotkey_id, GetApplicationEventTarget(), 0, &hotkey);

  hotkey_id.signature    = 'rght';
  hotkey_id.id           = 1;
  RegisterEventHotKey(124, cmdKey + shiftKey, hotkey_id, GetApplicationEventTarget(), 0, &hotkey);

  InstallApplicationEventHandler(&hotkey_handler, 1, &event_type, NULL, NULL);
}

OSStatus hotkey_handler(EventHandlerCallRef next_handler, EventRef event, void *user_data) {
  int x, y;

  EventHotKeyID hotkey;
  GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotkey), NULL, &hotkey);

  // 0 for left, 1 for right
  if (!hotkey.id) {
    x = -2000;
    y = 500;
  } else {
    x = 2000;
    y = 500;
  }

  NSLog(@"moving to %d, %d", x, y);
  CGPoint pt;
  pt.x = x;
  pt.y = y;

  CGEventRef ev = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, pt, kCGMouseButtonLeft);
  CGEventSetType(ev, kCGEventMouseMoved);
  CGEventPost(kCGHIDEventTap, ev);
  CFRelease(ev);

  return noErr;
}

