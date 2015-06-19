# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_rpaf/mod_rpaf-0.6.ebuild,v 1.4 2012/10/12 08:30:58 patrick Exp $

inherit apache-module

DESCRIPTION="Reverse proxy add forward module"
HOMEPAGE="http://stderr.net/apache/rpaf/"
SRC_URI="http://stderr.net/apache/rpaf/download/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="RPAF"

need_apache2_2

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv ${PN}-2.0.c ${PN}.c
}
