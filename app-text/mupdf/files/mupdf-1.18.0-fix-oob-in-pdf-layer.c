From b82e9b6d6b46877e5c3763cc3bc641c66fa7eb54 Mon Sep 17 00:00:00 2001
From: Robin Watts <Robin.Watts@artifex.com>
Date: Thu, 8 Oct 2020 16:15:40 +0100
Subject: [PATCH] Bug 701297: Harden populate_ui against unexpected repairs.

We count the number of layers, and allocate space for them in
an array. We then walk the tree reading details of those layers
in. If we hit a problem that causes a repair while reading the
information, the number of layers can magically increase. In
the existing code we run off the end of the array.

In the new code we watch for hitting the end of the array and
realloc as required.
---
 source/pdf/pdf-layer.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/source/pdf/pdf-layer.c b/source/pdf/pdf-layer.c
index 177f0c947..b8e9d7cad 100644
--- a/source/pdf/pdf-layer.c
+++ b/source/pdf/pdf-layer.c
@@ -104,10 +104,27 @@ count_entries(fz_context *ctx, pdf_obj *obj)
 }
 
 static pdf_ocg_ui *
-populate_ui(fz_context *ctx, pdf_ocg_descriptor *desc, pdf_ocg_ui *ui, pdf_obj *order, int depth, pdf_obj *rbgroups, pdf_obj *locked)
+get_ocg_ui(fz_context *ctx, pdf_ocg_descriptor *desc, int fill)
+{
+	if (fill == desc->num_ui_entries)
+	{
+		/* Number of layers changed while parsing;
+		 * probably due to a repair. */
+		int newsize = desc->num_ui_entries * 2;
+		if (newsize == 0)
+			newsize = 4; /* Arbitrary non-zero */
+		desc->ui = fz_realloc_array(ctx, desc->ui, newsize, pdf_ocg_ui);
+		desc->num_ui_entries = newsize;
+	}
+	return &desc->ui[fill];
+}
+
+static int
+populate_ui(fz_context *ctx, pdf_ocg_descriptor *desc, int fill, pdf_obj *order, int depth, pdf_obj *rbgroups, pdf_obj *locked)
 {
 	int len = pdf_array_len(ctx, order);
 	int i, j;
+	pdf_ocg_ui *ui;
 
 	for (i = 0; i < len; i++)
 	{
@@ -118,7 +135,7 @@ populate_ui(fz_context *ctx, pdf_ocg_descriptor *desc, pdf_ocg_ui *ui, pdf_obj *
 				continue;
 
 			fz_try(ctx)
-				ui = populate_ui(ctx, desc, ui, o, depth+1, rbgroups, locked);
+				fill = populate_ui(ctx, desc, fill, o, depth+1, rbgroups, locked);
 			fz_always(ctx)
 				pdf_unmark_obj(ctx, o);
 			fz_catch(ctx)
@@ -126,14 +143,14 @@ populate_ui(fz_context *ctx, pdf_ocg_descriptor *desc, pdf_ocg_ui *ui, pdf_obj *
 
 			continue;
 		}
-		ui->depth = depth;
 		if (pdf_is_string(ctx, o))
 		{
+			ui = get_ocg_ui(ctx, desc, fill++);
+			ui->depth = depth;
 			ui->ocg = -1;
 			ui->name = pdf_to_str_buf(ctx, o);
 			ui->button_flags = PDF_LAYER_UI_LABEL;
 			ui->locked = 1;
-			ui++;
 			continue;
 		}
 
@@ -144,13 +161,14 @@ populate_ui(fz_context *ctx, pdf_ocg_descriptor *desc, pdf_ocg_ui *ui, pdf_obj *
 		}
 		if (j == desc->len)
 			continue; /* OCG not found in main list! Just ignore it */
+		ui = get_ocg_ui(ctx, desc, fill++);
+		ui->depth = depth;
 		ui->ocg = j;
 		ui->name = pdf_dict_get_string(ctx, o, PDF_NAME(Name), NULL);
 		ui->button_flags = pdf_array_contains(ctx, o, rbgroups) ? PDF_LAYER_UI_RADIOBOX : PDF_LAYER_UI_CHECKBOX;
 		ui->locked = pdf_array_contains(ctx, o, locked);
-		ui++;
 	}
-	return ui;
+	return fill;
 }
 
 static void
@@ -188,7 +206,7 @@ load_ui(fz_context *ctx, pdf_ocg_descriptor *desc, pdf_obj *ocprops, pdf_obj *oc
 	desc->ui = Memento_label(fz_calloc(ctx, count, sizeof(pdf_ocg_ui)), "pdf_ocg_ui");
 	fz_try(ctx)
 	{
-		(void)populate_ui(ctx, desc, desc->ui, order, 0, rbgroups, locked);
+		desc->num_ui_entries = populate_ui(ctx, desc, 0, order, 0, rbgroups, locked);
 	}
 	fz_catch(ctx)
 	{
