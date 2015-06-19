# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_rpaf/mod_rpaf-0.6-r1.ebuild,v 1.1 2015/05/09 11:55:19 pacho Exp $

EAPI=5
inherit apache-module eutils

DESCRIPTION="Reverse proxy add forward module"
HOMEPAGE="http://stderr.net/apache/rpaf/"
SRC_URI="http://stderr.net/apache/rpaf/download/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="RPAF"

need_apache2_4

src_prepare() {
	# Debian patches
	epatch "${FILESDIR}"/0*.patch
	mv ${PN}-2.0.c ${PN}.c
}
