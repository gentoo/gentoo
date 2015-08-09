# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

MY_NCBI_BLAST_V=2.2.23+

DESCRIPTION="RepeatMasker compatible version of NCBI BLAST+"
HOMEPAGE="http://www.repeatmasker.org/RMBlast.html"
SRC_URI="http://www.repeatmasker.org/rmblast-${PV}-ncbi-blast-${MY_NCBI_BLAST_V}-src.tar.gz"

LICENSE="OSL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	app-arch/cpio"

S="${WORKDIR}/${P}-ncbi-blast-${MY_NCBI_BLAST_V}-src/c++"

src_prepare() {
	filter-ldflags -Wl,--as-needed
	sed \
		-e 's/-print-file-name=libstdc++.a//' \
		-e '/sed/ s/\([gO]\[0-9\]\)\*/\1\\+/' \
		-e "/DEF_FAST_FLAGS=/s:=\".*\":=\"${CFLAGS}\":g" \
		-i src/build-system/configure || die
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	tc-export CXX CC

	"${S}"/configure --without-debug \
		--with-mt \
		--without-static \
		--with-dll \
		--prefix="${ED}"/opt/${PN} \
		--with-boost="${EPREFIX}/usr/include/boost" \
		|| die
}
