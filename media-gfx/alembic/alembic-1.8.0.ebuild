# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
# arm{,64} either pyilmbase needs to be keyworded or imath merged and keyworded
# to re-add python / pyalembic support
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="examples hdf5 test"
RESTRICT="!test? ( test )"

# TODO: once imath has been merge, switch to use imath instead
# of ilmbase
RDEPEND="
	>=media-libs/ilmbase-2.5.5:=
	hdf5? (
		>=sci-libs/hdf5-1.10.2:=[zlib(+)]
		>=sys-libs/zlib-1.2.11-r1
	)
"
DEPEND="${RDEPEND}"

DOCS=( ACKNOWLEDGEMENTS.txt FEEDBACK.txt NEWS.txt README.txt )

PATCHES=( "${FILESDIR}/${P}-0001-set-correct-libdir.patch" )

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_BUILD_LIBS=ON
		-DALEMBIC_SHARED_LIBS=ON
		-DDOCS_PATH=OFF	# currently does nothing but require doxygen
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=OFF
		# TODO: needs imath merged and keyworded for arm{,64}
		-DUSE_PYALEMBIC=OFF
		-DUSE_TESTS=$(usex test)
	)

	cmake_src_configure
}
