# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2

DESCRIPTION="A mesh and field I/O library and scientific database"
HOMEPAGE="https://wci.llnl.gov/simulation/computer-codes/silo"
SRC_URI="https://wci.llnl.gov/sites/wci/files/2021-09/${P}-bsd.tgz"
S="${WORKDIR}/${P}-bsd"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="browser +hdf5 +silex"
# Waiting for fix/answer upstream
# See https://github.com/LLNL/Silo/issues/234
RESTRICT="test"

RDEPEND="
	dev-qt/qtgui:5
	virtual/szip
	hdf5? ( sci-libs/hdf5 )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-autoreconf.patch
	"${FILESDIR}"/${P}-hdf5.patch
	"${FILESDIR}"/${P}-test-disable-largefile.patch
	"${FILESDIR}"/${P}-tests.patch
	"${FILESDIR}"/${P}-testsuite-python-write.patch
)

src_configure() {
	econf \
		--enable-install-lite-headers \
		--enable-shared \
		$(use_enable silex silex ) \
		$(use_enable browser browser ) \
		$(use_with hdf5 hdf5 "${EPREFIX}"/usr/include,"${EPREFIX}"/usr/$(get_libdir) )
}

# src_test() {
#	emake -C tests check
# }
