$NetBSD: patch-libgnomevfs_gnome-vfs-ssl.c,v 1.1 2018/02/16 13:18:26 wiz Exp $

struct SSL is opaque in openssl-1.1; and the SSL_free() man page
says that one should not free members of it manually (in both
the openssl-1.0 and openssl-1.1 man pages).

--- libgnomevfs/gnome-vfs-ssl.c.orig	2010-02-09 12:16:14.000000000 +0000
+++ libgnomevfs/gnome-vfs-ssl.c
@@ -400,9 +400,6 @@ gnome_vfs_ssl_create_from_fd (GnomeVFSSS
 			}
 		}
 
-                if (ssl->private->ssl->ctx)
-                        SSL_CTX_free (ssl->private->ssl->ctx);
-
                 SSL_free (ssl->private->ssl);
 		g_free (ssl->private);
 		g_free (ssl);
@@ -705,7 +702,6 @@ gnome_vfs_ssl_destroy (GnomeVFSSSL *ssl,
 		}
 	}
 	
-	SSL_CTX_free (ssl->private->ssl->ctx);
 	SSL_free (ssl->private->ssl);
 	close (ssl->private->sockfd);
 	if (ssl->private->timeout)
