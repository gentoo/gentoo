# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="feature rich database generator for high performance C applications"
HOMEPAGE="http://datadraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}${PV}/${PN}${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

S="${WORKDIR}/${PN}${PV}"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_configure() {
	tc-export AR CC
	default
}

src_install() {
	dobin datadraw

	local lib
	for lib in util/*.a; do
		newlib.a ${lib} lib${lib#*/}
	done

	doheader util/*.h

	HTML_DOCS=( www/index.html www/images )
	einstalldocs
	dodoc manual.pdf

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
