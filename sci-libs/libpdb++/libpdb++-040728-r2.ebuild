# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="PDB Record I/O Libraries -- c++ version"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="mirror://gentoo/f8/${P}.shar"
S=${WORKDIR}/${PN}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

BDEPEND="app-arch/sharutils"

PATCHES=( "${FILESDIR}"/${P}-dynlib+flags.patch )

src_unpack() {
	edo unshar "${DISTDIR}"/${A}
}

src_prepare() {
	default
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
