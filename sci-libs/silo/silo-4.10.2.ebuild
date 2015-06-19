# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/silo/silo-4.10.2.ebuild,v 1.1 2015/01/08 12:31:38 slis Exp $

EAPI=5

inherit eutils

DESCRIPTION="A mesh and field I/O library and scientific database"
HOMEPAGE="https://wci.llnl.gov/simulation/computer-codes/silo"
SRC_URI="https://wci.llnl.gov/content/assets/docs/simulation/computer-codes/${PN}/${P}/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="hdf5 +silex static-libs qt4 test"

REQUIRED_USE="silex? ( qt4 )"

RDEPEND="
	hdf5? ( sci-libs/hdf5 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-qtlibs.patch"
	epatch "${FILESDIR}/${P}-tests.patch"
}

src_configure() {
	econf \
		--enable-install-lite-headers \
		--enable-shared \
		$(use_enable silex silex ) \
		$(use_enable static-libs static ) \
		$(use_with qt4 Qt-lib-dir "${EPREFIX}"/usr/lib${LIB_LOCATION_SUFFIX}/qt4 ) \
		$(use_with qt4 Qt-include-dir "${EPREFIX}"/usr/include/qt4 ) \
		$(use_with hdf5 hdf5 ${EPREFIX}"/usr/include,${EPREFIX}"/usr/lib${LIB_LOCATION_SUFFIX} )
}
