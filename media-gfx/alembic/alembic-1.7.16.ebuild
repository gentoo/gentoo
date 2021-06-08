# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multiprocessing

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="hdf5 test zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="hdf5? ( zlib )"

RDEPEND="
	>=media-libs/openexr-2.5.0:=
	hdf5? ( >=sci-libs/hdf5-1.10.2:=[zlib(+)] )
	zlib? ( >=sys-libs/zlib-1.2.11-r1 )
"
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( "ACKNOWLEDGEMENTS.txt" "FEEDBACK.txt" "NEWS.txt" "README.txt" )

PATCHES=( "${FILESDIR}/${PN}-1.7.11-0005-Fix-install-locations.patch" )

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_SHARED_LIBS=ON
		# C++-11 and thus {shared,unique,weak}_ptr are common nowadays, so these
		# are no longer needed and using boost fails. Options will get removed by
		# upstream soon
		-DALEMBIC_LIB_USES_BOOST=OFF
		-DALEMBIC_LIB_USES_TR1=OFF
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=OFF
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=OFF
		-DUSE_PYALEMBIC=OFF
		-DUSE_TESTS=$(usex test)
	)

	cmake_src_configure
}
