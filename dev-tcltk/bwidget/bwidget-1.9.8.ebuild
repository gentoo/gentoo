# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib virtualx

MY_PN=${PN/bw/BW}
MY_P=${MY_PN}-${PV}

DESCRIPTION="High-level widget set for Tcl/Tk"
HOMEPAGE="http://tcllib.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/tcllib/${MY_PN}/${PV}/${P}.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="doc"

DEPEND="dev-lang/tk:0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-test.patch
}

src_test() {
	VIRTUALX_COMMAND=tclsh
	virtualmake tests/entry.test
}

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins *.tcl
	doins -r images lang

	insinto /usr/share/doc/${PF}/
	doins -r demo
	dodoc ChangeLog README.txt

	use doc && dohtml BWman/*
}
