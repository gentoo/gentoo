# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils flag-o-matic toolchain-funcs

DESCRIPTION="Transcript assembly, differential expression, and differential regulation for RNA-Seq"
HOMEPAGE="http://cufflinks.cbcb.umd.edu/"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-biology/samtools-0.1.18
	<sci-biology/samtools-1
	>=dev-libs/boost-1.47.0:=
	<dev-libs/boost-1.56.0:=
	dev-cpp/eigen:3
"
RDEPEND="${DEPEND}"

src_prepare() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags eigen3)
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-optim
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)/"
		--with-bam="${EPREFIX}/usr/"
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
