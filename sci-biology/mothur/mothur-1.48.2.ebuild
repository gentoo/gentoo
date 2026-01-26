# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Suite of algorithms for ecological bioinformatics"
HOMEPAGE="https://mothur.org/"
SRC_URI="https://github.com/mothur/mothur/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="boost gsl hdf5 mpi +readline"

RDEPEND="
	sci-biology/uchime
	boost? ( dev-libs/boost:=[zlib] )
	gsl? ( sci-libs/gsl:= )
	hdf5? ( sci-libs/hdf5:=[cxx] )
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.48.0-build.patch
	"${FILESDIR}"/${P}-boost-1.89.patch # bug 965517
)

src_configure() {
	use mpi && export CXX=mpicxx || tc-export CXX
	use amd64 && append-cppflags -DBIT_VERSION
}

src_compile() {
	# bug #862273
	append-flags -fno-strict-aliasing
	filter-lto

	# USEBOOST - link with boost libraries. Must install boost. Allows the make.contigs command to read .gz files.
	# USEHDF5 - link with HDF5cpp libraries. Must install HDF5. Allows the biom.info command to read Biom format 2.0.
	# USEGSL - link with GNU Scientific libraries. Must install GSL. Allows the estimiator.single command to find diversity estimates.
	emake \
		USEBOOST=$(usex boost) \
		USEHDF5=$(usex hdf5) \
		USEGSL=$(usex gsl) \
		USEMPI=$(usex mpi) \
		USEREADLINE=$(usex readline) \
		OPTIMIZE=no
}

src_install() {
	dobin mothur
}
