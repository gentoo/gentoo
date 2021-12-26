# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_OPTIONAL=1

inherit cmake distutils-r1

DESCRIPTION="A C++ library for translating and manipulating point cloud data"
HOMEPAGE="https://pdal.io/"
SRC_URI="https://github.com/PDAL/PDAL/releases/download/${PV}/PDAL-${PV}-src.tar.gz"

SLOT="0/13"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="postgres python sqlite"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	virtual/pkgconfig
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

DEPEND="
	sci-libs/gdal
	sci-libs/libgeotiff
	sci-geosciences/laszip
	dev-libs/jsoncpp
	sys-libs/libunwind
	sqlite? ( dev-db/sqlite )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/PDAL-${PV}-src"

src_prepare() {
	eapply_user
	sed -i -e 's:"${PDAL_LIB_INSTALL_DIR}/cmake/PDAL":"lib/cmake/PDAL":' CMakeLists.txt || die "sed failed!"

	cmake_src_prepare
}
