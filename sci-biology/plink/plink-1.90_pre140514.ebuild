# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Whole genome association analysis toolset"
HOMEPAGE="http://pngu.mgh.harvard.edu/~purcell/plink/"
SRC_URI="http://pngu.mgh.harvard.edu/~purcell/static/bin/plink140514/plink_src.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/unzip
	virtual/pkgconfig"
RDEPEND="
	sys-libs/zlib
	virtual/cblas
	virtual/lapack
	"

S="${WORKDIR}/"

# Package collides with net-misc/putty. Renamed to p-link following discussion with Debian.
# Package contains bytecode-only jar gPLINK.jar. Ignored, notified upstream.

src_prepare() {
	sed \
		-e 's:zlib-1.2.8/zlib.h:zlib.h:g' \
		-i *.{c,h} || die

	sed \
		-e 's:g++:$(CXX):g' \
		-e 's:gcc:$(CC):g' \
		-e 's:gfortran:$(FC):g' \
		-i Makefile || die
	tc-export PKG_CONFIG
}

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		ZLIB="$($(tc-getPKG_CONFIG) --libs zlib)" \
		BLASFLAGS="$($(tc-getPKG_CONFIG) --libs lapack cblas)"
}

src_install() {
	newbin plink p-link
}
