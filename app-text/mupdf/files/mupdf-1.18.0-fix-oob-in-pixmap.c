From 32e4e8b4bcbacbf92af7c88337efae21986d9603 Mon Sep 17 00:00:00 2001
From: Robin Watts <Robin.Watts@artifex.com>
Date: Thu, 8 Oct 2020 18:10:28 +0100
Subject: [PATCH] Bug 702958: Fix overflow in fz_clear_pixmap_with_value.

---
 source/fitz/pixmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/source/fitz/pixmap.c b/source/fitz/pixmap.c
index 66873d214..80d8bb62f 100644
--- a/source/fitz/pixmap.c
+++ b/source/fitz/pixmap.c
@@ -555,7 +555,8 @@ void
 fz_clear_pixmap_with_value(fz_context *ctx, fz_pixmap *pix, int value)
 {
 	unsigned char *s;
-	int w, h, n, stride, len;
+	int w, h, n;
+	ptrdiff_t stride, len;
 	int alpha = pix->alpha;
 
 	w = pix->w;
@@ -572,7 +573,7 @@ fz_clear_pixmap_with_value(fz_context *ctx, fz_pixmap *pix, int value)
 
 	n = pix->n;
 	stride = pix->stride;
-	len = w * n;
+	len = (ptrdiff_t)w * n;
 
 	s = pix->samples;
 	if (value == 255 || !alpha)
@@ -584,7 +585,7 @@ fz_clear_pixmap_with_value(fz_context *ctx, fz_pixmap *pix, int value)
 		}
 		while (h--)
 		{
-			memset(s, value, (unsigned int)len);
+			memset(s, value, len);
 			s += stride;
 		}
 	}
