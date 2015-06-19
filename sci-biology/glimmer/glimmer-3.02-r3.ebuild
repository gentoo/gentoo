# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/glimmer/glimmer-3.02-r3.ebuild,v 1.3 2015/05/27 11:01:14 ago Exp $

EAPI="5"

inherit eutils toolchain-funcs

MY_PV=${PV//./}

DESCRIPTION="An HMM-based microbial gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/glimmer/"
SRC_URI="http://www.cbcb.umd.edu/software/${PN}/${PN}${MY_PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="app-shells/tcsh"

S="${WORKDIR}/${PN}${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-glibc210.patch
	"${FILESDIR}"/${P}-jobserver-fix.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${PN}-3.02b-rename_extract.patch
)

src_prepare() {
	sed -i -e 's|\(set awkpath =\).*|\1 /usr/share/'${PN}'/scripts|' \
		-e 's|\(set glimmerpath =\).*|\1 /usr/bin|' scripts/* || die "failed to rewrite paths"
	# Fix Makefile to die on failure
	sed -i 's/$(MAKE) $(TGT)/$(MAKE) $(TGT) || exit 1/' src/c_make.gen || die
	# GCC 4.3 include fix
	sed -i 's/include  <string>/include  <string.h>/' src/Common/delcher.hh || die
	epatch "${PATCHES[@]}"
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

	insinto /usr/share/${PN}
	doins -r scripts

	dodoc glim302notes.pdf
}
