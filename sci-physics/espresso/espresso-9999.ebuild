# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake cuda python-single-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="https://espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}md/${PN}.git"
	EGIT_BRANCH="python"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}md/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda doc examples +fftw +hdf5 test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}"

# cmake built hdf5 fails to detect, -r1 switched to cmake
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/cython-0.26.1[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	dev-libs/boost:=[mpi]
	hdf5? ( <sci-libs/hdf5-1.14.6-r1:=[mpi] )
"

DEPEND="${RDEPEND}
	doc? (
		app-text/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/scipy[${PYTHON_USEDEP}]
		')
	)
"

DOCS=( AUTHORS NEWS Readme.md ChangeLog )

PATCHES=(
	"${FILESDIR}"/${P}-test-deps-only.patch
)

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
	# allow cython 3.1
	sed -i '/Cython/{s/3\.1\.0/4.0/}' CMakeLists.txt || die

	# These produce tests that aren't run by "make check", but ctest picks
	# them up by default, against upstream's intention.
	cd testsuite || die
	cmake_comment_add_subdirectory cmake scripts tutorials samples benchmarks
}

src_configure() {
	local mycmakeargs=(
		-DESPRESSO_BUILD_WITH_CUDA=$(usex cuda)
		-DPython_EXECUTABLE="${PYTHON}"
		# ignores site-packages dir and replaces with CMAKE_INSTALL_LIBDIR
		-DESPRESSO_INSTALL_PYTHON="$(python_get_sitedir)"
		-DESPRESSO_BUILD_TESTS=$(usex test)
		-DINSTALL_PYPRESSO=OFF
		-DESPRESSO_BUILD_WITH_FFTW=$(usex fftw)
		-DESPRESSO_BUILD_WITH_HDF5=$(usex hdf5)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doxygen
	[[ ${PV} = 9999 ]] && use doc && cmake_build ug dg tutorials
}

src_test() {
	# testsuite uses exclude_from_all, and lists all targets as deps for their custom rule
	cmake_build check
	cmake_src_test
}

src_install() {
	local i docdir="${S}"

	cmake_src_install

	python_optimize

	insinto /usr/share/${PN}/
	doins "${BUILD_DIR}/myconfig-sample.hpp"

	save_config "${BUILD_DIR}/src/config/include/config/myconfig-final.hpp"

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
