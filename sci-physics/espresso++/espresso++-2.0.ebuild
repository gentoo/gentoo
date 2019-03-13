# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils python-r1

DESCRIPTION="A Modern Multiscale Simulation Package for Soft Matter Systems"
HOMEPAGE="https://www.espresso-pp.de"

MY_PN="${PN//+/p}"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	virtual/mpi
	dev-libs/boost:=[python,mpi,${PYTHON_USEDEP}]
	sci-libs/fftw:3.0
	>=dev-python/mpi4py-2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	src_configure_internal() {
		local mycmakeargs=(
			-DEXTERNAL_BOOST=ON
			-DEXTERNAL_MPI4PY=ON
			-DWITH_RC_FILES=OFF
		)
		cmake-utils_src_configure
	}
	python_foreach_impl src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_make
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}
