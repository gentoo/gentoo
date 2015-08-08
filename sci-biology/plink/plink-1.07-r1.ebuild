# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Whole genome association analysis toolset"
HOMEPAGE="http://pngu.mgh.harvard.edu/~purcell/plink/"
SRC_URI="http://pngu.mgh.harvard.edu/~purcell/plink/dist/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
IUSE="lapack -webcheck R"
KEYWORDS="amd64 x86"

DEPEND="
	app-arch/unzip
	lapack? ( virtual/pkgconfig )"
RDEPEND="
	sys-libs/zlib
	lapack? ( virtual/lapack )"

S="${WORKDIR}/${P}-src"

# Package collides with net-misc/putty. Renamed to p-link following discussion with Debian.
# Package contains bytecode-only jar gPLINK.jar. Ignored, notified upstream.

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-flags.patch \
		"${FILESDIR}"/${P}-gcc47.patch
	use webcheck || sed -i '/WITH_WEBCHECK =/ s/^/#/' "${S}/Makefile" || die
	use R || sed -i '/WITH_R_PLUGINS =/ s/^/#/' "${S}/Makefile" || die
	use lapack || sed -i '/WITH_LAPACK =/ s/^/#/' "${S}/Makefile" || die
	tc-export PKG_CONFIG
}

src_compile() {
	emake \
		CXX_UNIX=$(tc-getCXX)
}

src_install() {
	newbin plink p-link
	dodoc README.txt
}
