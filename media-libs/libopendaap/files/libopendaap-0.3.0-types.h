--- libopendaap-0.3.0/mDNS/mDNSClientAPI.h.orig	2005-01-23 15:39:04.834290477 -0800
+++ libopendaap-0.3.0/mDNS/mDNSClientAPI.h	2005-01-23 15:39:41.512250333 -0800
@@ -483,8 +483,8 @@
 typedef unsigned char  mDNSu8;
 typedef   signed short mDNSs16;
 typedef unsigned short mDNSu16;
-typedef   signed long  mDNSs32;
-typedef unsigned long  mDNSu32;
+typedef   signed int   mDNSs32;
+typedef unsigned int   mDNSu32;
 
 // To enforce useful type checking, we make mDNSInterfaceID be a pointer to a dummy struct
 // This way, mDNSInterfaceIDs can be assigned, and compared with each other, but not with other types
