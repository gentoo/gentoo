# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="PDB Record I/O Libraries -- c++ version"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="mirror://gentoo/${P}.shar"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/sharutils"

S="${WORKDIR}"/${PN}

src_unpack() {
	"${EPREFIX}/usr/bin/unshar" "${DISTDIR}"/${A} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-dynlib+flags.patch
	tc-export CXX AR RANLIB
}

src_compile() {
	emake ${PN}.so
	use static-libs && emake ${PN}.a
}

src_install() {
	dolib.so ${PN}.so*
	use static-libs && dolib.a ${PN}.a

	insinto /usr/include/${PN}
	doins *.h
}
