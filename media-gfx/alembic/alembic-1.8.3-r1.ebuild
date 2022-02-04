# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit cmake python-single-r1

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="examples hdf5 python test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	>=media-libs/ilmbase-2.5.5:=
	python? ( >=dev-python/pyilmbase-2.5.5[${PYTHON_SINGLE_USEDEP}] )
	hdf5? (
		>=sci-libs/hdf5-1.10.2:=[zlib(+)]
		>=sys-libs/zlib-1.2.11-r1
	)
	python? ( $(python_gen_cond_dep 'dev-libs/boost[python,${PYTHON_USEDEP}]') )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0-0001-set-correct-libdir.patch
	"${FILESDIR}"/${P}-0001-find-py-ilmbase-in-config-mode.patch
)

DOCS=( ACKNOWLEDGEMENTS.txt FEEDBACK.txt NEWS.txt README.txt )

src_prepare() {
	cmake_src_prepare
	# PyAlembic test doesn't properly find Imath, comment it for now
	cmake_run_in python/PyAlembic cmake_comment_add_subdirectory Tests
}

src_configure() {
	local mycmakeargs=(
		# Force falling back to ilmbase for now
		# bug #818232
		-DCMAKE_DISABLE_FIND_PACKAGE_Imath=ON

		-DALEMBIC_BUILD_LIBS=ON
		-DALEMBIC_SHARED_LIBS=ON
		# currently does nothing but require doxygen
		-DDOCS_PATH=OFF
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=OFF
		-DUSE_PYALEMBIC=$(usex python)
		-DUSE_TESTS=$(usex test)
	)

	use python && mycmakeargs+=( -DPython3_EXECUTABLE=${PYTHON} )

	cmake_src_configure
}
