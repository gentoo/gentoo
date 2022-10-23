# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic fortran-2 qmake-utils

DESCRIPTION="A mesh and field I/O library and scientific database"
HOMEPAGE="https://wci.llnl.gov/simulation/computer-codes/silo"
SRC_URI="https://wci.llnl.gov/sites/wci/files/2021-09/${P}-bsd.tgz"
S="${WORKDIR}/${P}-bsd"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="browser +hdf5 +silex"

# see bugs 656432 and 741741
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	net-dialup/lrzsz
	virtual/szip
	hdf5? ( sci-libs/hdf5 )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}"/${P}-hdf5.patch
	"${FILESDIR}"/${P}-test-disable-largefile.patch
	"${FILESDIR}"/${P}-tests.patch
	"${FILESDIR}"/${P}-testsuite-python-write.patch
	"${FILESDIR}"/${P}-widgets.patch
	"${FILESDIR}"/${P}-qtbindir.patch
)

src_configure() {
	# add fflags for fixing test bug on matf77.f
	# see https://github.com/LLNL/Silo/issues/234
	append-fflags $(test-flags-F77 -fallow-argument-mismatch)

	QMAKE=$(qt5_get_bindir)/qmake \
	QT_BIN_DIR=$(qt5_get_bindir) \
	econf \
		--enable-install-lite-headers \
		--enable-shared \
		$(use_enable silex silex ) \
		$(use_enable browser browser ) \
		$(use_with hdf5 hdf5 "${EPREFIX}"/usr/include,"${EPREFIX}"/usr/$(get_libdir) )
}

src_test() {
	# see https://github.com/LLNL/Silo/issues/236
	# some tests are skipped by default so we are gonna drop them directly
	emake ATARGS="1-34 36-44 50-51 66-76 78-81" -C tests check
}
