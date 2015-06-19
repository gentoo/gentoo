# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ksdssp/ksdssp-040728.ebuild,v 1.3 2012/10/18 16:30:03 jlec Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="ksdssp is an open source implementation of dssp"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="mirror://gentoo/${P}.shar"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
IUSE=""

RDEPEND="sci-libs/libpdb++"
DEPEND="
	${RDEPEND}
	app-arch/sharutils"

S="${WORKDIR}"/${PN}

src_unpack() {
	"${EPREFIX}"/usr/bin/unshar "${DISTDIR}"/${A}
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		PDBINCDIR="${EPREFIX}/usr/include/libpdb++" \
		BINDIR="${EPREFIX}/usr/bin" \
		.TARGET="${PN}.csh" \
		.CURDIR="${S}" \
		CC="$(tc-getCXX)" \
		LINKER="$(tc-getCXX)" \
		OPT="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		${PN} ${PN}.csh
}

src_install() {
	dobin ${PN}{,.csh}
}
