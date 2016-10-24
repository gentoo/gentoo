commit 3ddbf895db678fb40f7513bac9dbc36fd4095693
Author: Sergei Trofimovich <slyfox@gentoo.org>
Date:   Mon Oct 24 09:08:53 2016 +0100

    ioctl.h: add missing kernel compatibility header for BUILD_ASSERT
    
    Header breakage noticed by cynede. Reproducible as:
    
        $ gcc -c /usr/include/btrfs/ioctl.h -o /tmp/a.o
            /usr/include/btrfs/ioctl.h:42:14: error: expected declaration specifiers or '...' before 'sizeof'
         BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
                      ^~~~~~
    
    Basically gcc tries to say us BUILD_ASSERT is not visible.
    
    BUILD_ASSERT lives in kerncompat.h which this change adds.
    
    Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

diff --git a/ioctl.h b/ioctl.h
index a7235c0..abea7ed 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -26,6 +26,12 @@ extern "C" {
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+#if BTRFS_FLAT_INCLUDES
+#include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
+
 #ifndef __user
 #define __user
 #endif
