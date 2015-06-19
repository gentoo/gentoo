# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libpdb++/libpdb++-040728.ebuild,v 1.4 2012/10/18 16:46:29 jlec Exp $

EAPI="3"

inherit eutils multilib toolchain-funcs

DESCRIPTION="PDB Record I/O Libraries -- c++ version"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="mirror://gentoo/${P}.shar"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/sharutils"

S="${WORKDIR}"/${PN}

src_unpack() {
	"${EPREFIX}"/usr/bin/unshar "${DISTDIR}"/${A} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-dynlib.patch
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CCFLAGS="${CXXFLAGS} -fPIC -felide-constructors" \
		|| die
}

src_install() {
	dolib.a ${PN}.a || die
	dolib.so ${PN}.so.0.1 || die
	dosym ${PN}.so.0.1 /usr/$(get_libdir)/${PN}.so.0
	dosym ${PN}.so.0.1 /usr/$(get_libdir)/${PN}.so
	insinto /usr/include/${PN}
	doins *.h || die
}
