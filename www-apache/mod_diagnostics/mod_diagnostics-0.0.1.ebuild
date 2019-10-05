# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit apache-module

KEYWORDS="x86"

DESCRIPTION="An Apache2 module which can do debugging of modules in the Apache2 Filter Chain"
HOMEPAGE="http://apache.webthing.com/mod_diagnostics/"
SRC_URI="mirror://gentoo/${P}.c"
LICENSE="Apache-1.1"
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
