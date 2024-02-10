# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An open source implementation of sci-chemistry/dssp"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="mirror://gentoo/${P}.shar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sci-libs/libpdb++"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/sharutils"

S="${WORKDIR}/${PN}"

src_unpack() {
	unshar "${DISTDIR}"/${A} || die
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
	dobin ksdssp{,.csh}

	HTML_DOCS=( ksdssp.html )
	einstalldocs

	doman ksdssp.1
}
