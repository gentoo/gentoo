# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_proxy_fcgi/mod_proxy_fcgi-0_p816361.ebuild,v 1.2 2012/10/12 08:23:31 patrick Exp $

inherit apache-module

DESCRIPTION="mod_proxy_fcgi is a FastCGI protocol handler for mod_proxy"
HOMEPAGE="http://httpd.apache.org"
SRC_URI="http://dev.gentoo.org/~hollow/distfiles/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="36_${PN}"
APACHE2_MOD_DEFINE="PROXY_FCGI"

need_apache2_2
