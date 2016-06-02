--- gst/goom/mmx.h.orig	2011-12-11 19:48:11.000000000 +0100
+++ gst/goom/mmx.h	2013-02-08 00:54:14.000000000 +0100
@@ -715,13 +715,13 @@ void zoom_filter_xmmx (int prevX, int pr
 	{ \
 		printf("emms()\n"); \
 		__asm__ __volatile__ ("emms" \
-                        "st(1)","st(2)","st(3)","st(4)","st(5)","st(6)","st(7)"); \
+                        "st", "st(1)","st(2)","st(3)","st(4)","st(5)","st(6)","st(7)"); \
 	}
 
 #else
 
 #define	emms() __asm__ __volatile__ ("emms"::: \
-                      "st(1)","st(2)","st(3)","st(4)","st(5)","st(6)","st(7)")
+                      "st", "st(1)","st(2)","st(3)","st(4)","st(5)","st(6)","st(7)")
 
 #endif
 
