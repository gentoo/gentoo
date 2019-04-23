# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils fortran-2

DESCRIPTION="A mesh and field I/O library and scientific database"
HOMEPAGE="https://wci.llnl.gov/simulation/computer-codes/silo"
SRC_URI="https://wci.llnl.gov/content/assets/docs/simulation/computer-codes/${PN}/${P}/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="hdf5 +silex static-libs +qt5 test"

REQUIRED_USE="silex? ( qt5 )"

RDEPEND="
	hdf5? ( sci-libs/hdf5 )
	qt5? ( dev-qt/qtgui:5 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-qtlibs.patch"
	epatch "${FILESDIR}/${P}-qt5.patch"
	epatch "${FILESDIR}/${P}-tests.patch"
	epatch "${FILESDIR}/${P}-mpiposix.patch"
}

src_configure() {
	econf \
		--enable-install-lite-headers \
		--enable-shared \
		$(use_enable silex silex ) \
		$(use_enable static-libs static ) \
		$(use_with qt5 Qt-lib-dir "${EPREFIX}"/usr/$(get_libdir) ) \
		$(use_with qt5 Qt-include-dir "${EPREFIX}"/usr/include/qt5 ) \
		$(use_with qt5 Qt-bin-dir "${EPREFIX}"/usr/$(get_libdir)/qt5/bin ) \
		$(use_with hdf5 hdf5 ${EPREFIX}"/usr/include,${EPREFIX}"/usr/$(get_libdir) )
}
