# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Transcript assembly and differential expression/regulation for RNA-Seq"
HOMEPAGE="http://cufflinks.cbcb.umd.edu/"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sci-biology/samtools:0.1-legacy
	>=dev-libs/boost-1.62.0:=
	${PYTHON_DEPS}"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-samtools-legacy.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-boost-1.65-tr1-removal.patch
)

src_prepare() {
	default
	python_fix_shebang src/cuffmerge

	eautoreconf
}

src_configure() {
	# keep in sync with Boost
	append-cxxflags -std=c++14
	append-cppflags $($(tc-getPKG_CONFIG) --cflags eigen3)

	econf \
		--disable-optim \
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)/" \
		--with-bam="${EPREFIX}/usr/" \
		$(use_enable debug) \
		PYTHON="${PYTHON}"
}
