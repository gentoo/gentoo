diff -Naur libopendaap-0.2.3.orig/mDNS/mDNSClientAPI.h libopendaap-0.2.3/mDNS/mDNSClientAPI.h
--- libopendaap-0.2.3.orig/mDNS/mDNSClientAPI.h	2004-04-13 00:05:11.000000000 -0700
+++ libopendaap-0.2.3/mDNS/mDNSClientAPI.h	2004-10-05 12:58:19.996946514 -0700
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
