# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CODE=3476243c3e

DESCRIPTION="Collection of utility modules for Tk, and a companion to Tcllib"
HOMEPAGE="http://www.tcl.tk/software/tklib"
SRC_URI="https://core.tcl-lang.org/${PN}/raw/${P}.tar.bz2?name=${CODE} -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
