# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx

DESCRIPTION="High-level widget set for Tcl/Tk"
HOMEPAGE="http://tcllib.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/tcllib/BWidget/${PV}/${P}.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE="doc"
RESTRICT="!test? ( test )"

DEPEND="dev-lang/tk:0"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PN}-1.9.8-test.patch )

src_test() {
	TCLLIBPATH=${S} virtx tclsh tests/entry.test
}

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins *.tcl
	doins -r images lang

	dodoc -r demo
	dodoc ChangeLog README.txt

	docinto html
	use doc && dodoc -r BWman/*
}
