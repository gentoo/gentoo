# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="Simulation software to model electromagnetic systems"
HOMEPAGE="http://ab-initio.mit.edu/meep/"
SRC_URI="http://ab-initio.mit.edu/meep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples hdf5 guile mpi"

DEPEND="sci-libs/fftw
	sci-libs/gsl
	sci-physics/harminv
	guile? ( >=sci-libs/libctl-3.0.3 )
	hdf5? ( sci-libs/hdf5 )
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-shared \
		$(use_with mpi) \
		$(use_with hdf5) \
		$(use_with guile libctl)
}

src_test() {
	# bug #423247
	emake pml -C tests CXXFLAGS=-O0 || die
	emake check || die
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
	insinto /usr/share/doc/${PF}
	if use examples; then
		doins -r examples || die "install examples failed"
	fi
}
