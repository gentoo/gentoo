# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit apache-module

DESCRIPTION="An Apache2 backend authentication module that uses cookies and MySQL"
HOMEPAGE="http://home.digithi.de/digithi/dev/mod_auth_cookie_mysql/"
SRC_URI="http://home.digithi.de/digithi/dev/mod_auth_cookie_mysql/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/mysql"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/-/_}"

APXS2_ARGS="-DMODULE_NAME=mod_auth_cookie_mysql2 -DMODULE_NAME_module=auth_cookie_mysql2_module
	-I/usr/include/mysql -lmysqlclient -lz -c mod_auth_cookie_sql2.c mod_auth_cookie_sql2_mysql.c"
APACHE2_MOD_FILE="${S}/.libs/mod_auth_cookie_sql2.so"
APACHE2_MOD_CONF="55_${PN}"
APACHE2_MOD_DEFINE="AUTH_COOKIE_MYSQL2"

DOCFILES="README"

need_apache2_2
