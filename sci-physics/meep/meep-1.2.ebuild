# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Simulation software to model electromagnetic systems"
HOMEPAGE="http://ab-initio.mit.edu/meep/"
SRC_URI="http://ab-initio.mit.edu/meep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples hdf5 guile mpb mpi"

RDEPEND="
	sci-libs/fftw
	sci-libs/gsl
	sci-physics/harminv
	guile? ( >=sci-libs/libctl-3.2 )
	hdf5? ( sci-libs/hdf5 )
	mpb? ( sci-physics/mpb )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-pc-no-ldflags.patch
	"${FILESDIR}"/${P}-no-auto-mpb.patch
)

src_configure() {
	local myeconfargs=(
		$(use_with mpb)
		$(use_with mpi)
		$(use_with hdf5)
		$(use_with guile libctl)
	)
	autotools-utils_src_configure
}

src_test() {
	# pml test buggy with optimization on
	# http://thread.gmane.org/gmane.comp.science.electromagnetism.meep.general/4579
	pushd ${AUTOTOOLS_BUILD_DIR} > /dev/null
	emake -C tests pml CXXFLAGS="-O0"
	emake check
	popd > /dev/null
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*.ctl
	fi
}
