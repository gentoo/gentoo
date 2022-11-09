# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake cuda python-single-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}md/${PN}.git"
	EGIT_BRANCH="python"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}md/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
fi
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda doc examples +fftw +hdf5 test"

# unittest_decorators not packaged
RESTRICT="test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/cython-0.26.1[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	dev-libs/boost:=[mpi]
	hdf5? ( sci-libs/hdf5:=[mpi] )
"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
"

DOCS=( AUTHORS NEWS Readme.md ChangeLog )

PATCHES=(
	"${FILESDIR}/${P}-fix-disable-test.patch"
)

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DWITH_TESTS=$(usex test)
		-DINSTALL_PYPRESSO=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_FFTW3=$(usex !fftw)
		-DWITH_HDF5=$(usex hdf5)
		-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=$(usex !hdf5)
		-DCMAKE_SKIP_RPATH=YES
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doxygen
	[[ ${PV} = 9999 ]] && use doc && cmake_build ug dg tutorials
}

src_test() {
	LD_PRELOAD="${BUILD_DIR}/src/core/Espresso_core.so" cmake_src_test
}

src_install() {
	local i docdir="${S}"

	cmake_src_install

	python_optimize

	insinto /usr/share/${PN}/
	doins "${BUILD_DIR}/myconfig-sample.hpp"

	save_config "${BUILD_DIR}/src/config/myconfig-final.hpp"

	if use doc; then
		dodoc -r "${BUILD_DIR}/doc/doxygen/html"
	fi

	if use examples; then
		insinto "/usr/share/${PN}/examples/python"
		doins -r samples/${i}/.
	fi
}

pkg_postinst() {
	echo
	elog "Please read and cite:"
	elog "ESPResSo, Comput. Phys. Commun. 174(9) ,704, 2006."
	elog "https://dx.doi.org/10.1016/j.cpc.2005.10.005"
	echo
	elog "If you need more features, change"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
	elog "and reemerge with USE=savedconfig"
	echo
	elog "For a full feature list see:"
	elog "/usr/share/${PN}/myconfig-sample.hpp"
	echo
}
