# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CODE=6a397dec6188148cf6a6fe290cf2bd92a9190c42

DESCRIPTION="Collection of utility modules for Tk, and a companion to Tcllib"
HOMEPAGE="http://www.tcl.tk/software/tklib"
SRC_URI="http://core.tcl.tk/tklib/raw/${P}.tar.bz2?name=${CODE} -> ${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
IUSE="doc"

RDEPEND="
	dev-lang/tk:0
	dev-tcltk/tcllib"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-doc.patch )

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
	mv "${ED}"/usr/bin/dia{,-${PN}} || die
}
