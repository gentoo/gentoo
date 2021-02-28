Fixes build with kernel 5.11.

Bug: https://www.virtualbox.org/ticket/20198
Bug: https://bugs.gentoo.org/762994
From: jospezial@gmx.de

--- a/vboxnetflt/linux/VBoxNetFlt-linux.c
+++ b/vboxnetflt/linux/VBoxNetFlt-linux.c
@@ -38,6 +38,7 @@
 #include <linux/nsproxy.h>
 #endif
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/miscdevice.h>
