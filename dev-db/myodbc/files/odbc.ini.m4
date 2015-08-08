# $Id$
# vim:ts=4 noexpandtab ft=dosini:
#
[ODBC Data Sources]
__PN__-test = MySQL ODBC __PF__ Driver Testing DSN

# see http://www.mysql.com/products/myodbc/faq_toc.html
# for details about the following entry
[__PN__-test]
Description	= MySQL ODBC __PF__ Driver Testing DSN
Driver		= __PN__
Socket		= /var/run/mysqld/mysqld.sock
Server		= localhost
User		= root
Database	= test
Option		= 3
#Port		=
#Password	=
