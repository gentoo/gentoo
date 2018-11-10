# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Algorithm for detecting SNPs, indels, and other polymorphisms"
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd/"
SRC_URI="
	ftp://ftp.broad.mit.edu/pub/crd/VAAL/latest_source_code/${P}.tar.gz
	ftp://ftp.broad.mit.edu/pub/crd/VAAL/VAAL_manual.doc
	https://dev.gentoo.org/~mgorny/dist/${P}_remove-namespace-std.patch.bz2"

LICENSE="Whitehead-MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="openmp"

RDEPEND="
	!sci-biology/allpaths
	!sci-biology/allpathslg"
DEPEND="
	${RDEPEND}
	dev-libs/boost"

DOCS=( "${DISTDIR}/VAAL_manual.doc" )
PATCHES=(
	"${FILESDIR}/${P}-libieee.patch"
	"${WORKDIR}/${P}_remove-namespace-std.patch"
)

src_prepare() {
	sed \
		-e '/COPYING/d' \
		-i src/Makefile.am || die

	sed \
		-e 's:-ggdb::g' \
		-e '/AC_OPENMP_CEHCK/d' \
		-i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable openmp)
}
