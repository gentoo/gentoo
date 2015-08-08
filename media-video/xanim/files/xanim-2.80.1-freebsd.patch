--- xa_audio.h.old	Thu Apr 11 08:48:39 2002
+++ xa_audio.h	Thu Apr 11 08:49:25 2002
@@ -139,7 +139,11 @@
 #define _FILE_DSP "/dev/dsp"
 #define _FILE_MIXER "/dev/mixer"
 #ifdef __FreeBSD__
+#if __FreeBSD__ > 3
+#include <sys/soundcard.h>
+#else
 #include <machine/soundcard.h>
+#endif
 #else
 #include <sys/soundcard.h>
 #endif
