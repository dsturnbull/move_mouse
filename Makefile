move_mouse: move_mouse.m
	gcc -o move_mouse move_mouse.m -F/System/Library/Frameworks/Carbon.framework/Frameworks/ \
		-framework ApplicationServices -framework Foundation -framework Carbon -framework Carbon 
