# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_diagnostics/mod_diagnostics-0.0.1.ebuild,v 1.7 2014/08/10 20:15:22 slyfox Exp $

inherit apache-module

KEYWORDS="x86"

DESCRIPTION="An Apache2 module which can do debugging of modules in the Apache2 Filter Chain"
HOMEPAGE="http://apache.webthing.com/mod_diagnostics/"
SRC_URI="mirror://gentoo/${P}.c"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="DIAGNOSTICS"

need_apache2

src_unpack() {
	mkdir -p "${S}" || die "mkdir S failed"
	cp -f "${DISTDIR}/${P}.c" "${S}/${PN}.c" || die "source copy failed"
}
