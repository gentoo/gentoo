# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CODE=7832035fb9249dce

DESCRIPTION="Collection of utility modules for Tk, and a companion to Tcllib"
HOMEPAGE="http://www.tcl.tk/software/tklib"
SRC_URI="http://core.tcl.tk/${PN}/raw/${P}.tar.bz2?name=${CODE} -> ${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
IUSE="doc"

RDEPEND="
	dev-lang/tk:0
	dev-tcltk/tcllib"
DEPEND="${RDEPEND}"

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	HTML_DOCS=
	if use doc; then
		HTML_DOCS=doc/html/*
	fi
	default
	dodoc DESCRIPTION.txt
	dosym ${PN}${PV} /usr/$(get_libdir)/${PN}

	mv "${ED}"/usr/share/man/mann/datefield{,-${PN}}.n || die
	mv "${ED}"/usr/share/man/mann/menubar{,-${PN}}.n || die
}
