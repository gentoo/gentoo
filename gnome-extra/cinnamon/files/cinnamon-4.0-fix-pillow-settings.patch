--- files/usr/share/cinnamon/cinnamon-settings/bin/imtools.py.orig	2019-03-21 16:46:14 UTC
+++ files/usr/share/cinnamon/cinnamon-settings/bin/imtools.py
@@ -620,31 +620,6 @@ def has_transparency(image):
         has_alpha(image)
 
 
-if Image.VERSION == '1.1.7':
-
-    def split(image):
-        """Work around for bug in Pil 1.1.7
-
-        :param image: input image
-        :type image: PIL image object
-        :returns: the different color bands of the image (eg R, G, B)
-        :rtype: tuple
-        """
-        image.load()
-        return image.split()
-else:
-
-    def split(image):
-        """Work around for bug in Pil 1.1.7
-
-        :param image: input image
-        :type image: PIL image object
-        :returns: the different color bands of the image (eg R, G, B)
-        :rtype: tuple
-        """
-        return image.split()
-
-
 def get_alpha(image):
     """Gets the image alpha band. Can handles P mode images with transpareny.
     Returns a band with all values set to 255 if no alpha band exists.
@@ -655,7 +630,7 @@ def get_alpha(image):
     :rtype: single band image object
     """
     if has_alpha(image):
-        return split(image)[-1]
+        return image.split()[-1]
     if image.mode == 'P' and 'transparency' in image.info:
         return image.convert('RGBA').split()[-1]
     # No alpha layer, create one.
