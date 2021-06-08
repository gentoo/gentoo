# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV//./}

DESCRIPTION="An HMM-based microbial gene finding system from TIGR"
HOMEPAGE="https://ccb.jhu.edu/software/glimmer/index.shtml"
SRC_URI="https://ccb.jhu.edu/software/${PN}/${PN}${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}3.02"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-shells/tcsh
	sci-biology/elph"

PATCHES=(
	"${FILESDIR}"/${P}-jobserver-fix.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-rename_extract.patch
)

src_prepare() {
	sed -i -e 's|\(set awkpath =\).*|\1 /usr/share/'${PN}'/scripts|' \
		-e 's|\(set glimmerpath =\).*|\1 /usr/bin|' scripts/* || die "failed to rewrite paths"
	# Fix Makefile to die on failure
	sed -i 's/$(MAKE) $(TGT)/$(MAKE) $(TGT) || exit 1/' src/c_make.gen || die
	# GCC 4.3 include fix
	sed -i 's/include  <string>/include  <string.h>/' src/Common/delcher.hh || die
	#
	sed -i "s:/fs/szgenefinding/Glimmer3/bin:%${EPREFIX}/usr/bin/glimmer3:" scripts/g3-* || die
	sed -i "s:/fs/szgenefinding/Glimmer3/scripts:%${EPREFIX}/usr/share/glimmer/scripts:" scripts/g3-* || die
	sed -i "s:/nfshomes/adelcher/bin/elph:%${EPREFIX}/usr/bin/elph:" scripts/g3-* || die
	sed -i "s/@ if/if/" src/c_make.gen || die

	# avoid file collision on /usr/bin/extract #247394
	default
}

src_compile() {
	emake \
		-C src \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		CXXFLAGS="${CXXFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	rm bin/test || die
	dobin bin/*

	insinto /usr/share/glimmer
	doins -r scripts

	dodoc glim302notes.pdf
}
