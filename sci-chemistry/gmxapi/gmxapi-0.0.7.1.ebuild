# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MAKE_MAKEFILE_GENERATOR="ninja"

PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake-utils python-r1

DESCRIPTION="Gromacs API bindings"
HOMEPAGE="https://github.com/kassonlab/gmxapi"
SRC_URI="https://github.com/kassonlab/gmxapi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=sci-chemistry/gromacs-2019:="
RDEPEND="
	${DEPEND}
	sci-libs/scikits[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
"
BDEPEND=""

src_configure() {
	my_impl_src_configure() {
		local mycmakeargs=(
			-DCMAKE_STRIP="${EPREFIX}/bin/true"
			-DCMAKE_INSTALL_PREFIX="${ED%/}/usr"
			-DPYTHON_EXECUTABLE="${EPREFIX}/usr/bin/${EPYTHON}"
			-DGMXAPI_INSTALL_PATH="${EPREFIX}/usr/$(get_libdir)/${EPYTHON}/site-packages/gmx"
		)

		cmake-utils_src_configure
	}

	python_foreach_impl my_impl_src_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_make
}

src_install() {
	my_impl_src_install() {
		cd "${BUILD_DIR}" || die
		cmake-utils_src_install
		python_optimize
	}

	python_foreach_impl my_impl_src_install
}
