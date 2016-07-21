--- src/scim_hangul_imengine_setup.cpp.orig	2012-07-08 07:52:07.000000000 -0400
+++ src/scim_hangul_imengine_setup.cpp	2012-11-02 14:13:14.000000000 -0400
@@ -346,7 +346,7 @@
     for (i = 0; i < n; i++) {
 	const char* name = hangul_ic_get_keyboard_name(i);
 #if GTK_CHECK_VERSION(2, 24, 0)
-	gtk_combo_box_text_append(GTK_COMBO_BOX_TEXT(combo_box), NULL, name);
+	gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(combo_box), name);
 #else
 	gtk_combo_box_append_text(GTK_COMBO_BOX(combo_box), name);
 #endif
