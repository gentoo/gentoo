# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs

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

PATCHES=( "${FILESDIR}"/${P}-dynlib+flags.patch )

src_unpack() {
	"${EPREFIX}/usr/bin/unshar" "${DISTDIR}"/${A} || die
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
