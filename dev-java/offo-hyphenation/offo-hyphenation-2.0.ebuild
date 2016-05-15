# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Hyphenation patterns for Apache Fop"
HOMEPAGE="http://offo.sourceforge.net"
SRC_URI="mirror://sourceforge/offo/${PN}_v${PV}.zip"
LICENSE="GPL-2 Apache-2.0 LPPL-1.3b TeX"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() { :; }

src_install() {
	dodir /usr/share/${PN}/
	insinto /usr/share/${PN}/
	doins -r hyph

	if use doc; then
		dohtml -r images skin i*.html
	fi
}

pkg_postinst() {
	elog "This package installs hyphenation files for several languages"
	elog "into /usr/share/${PN}/hyph"
	elog "Check /usr/share/doc/${PF}/html/licenses.html for each file's license."
	elog "To compile the patterns, install dev-java/fop with USE=hyphenation."
	elog "Alternatively, use the uncompiled patterns via the <hyphenation-base>"
	elog "configuration option. See the documentation for more details."
}
