# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils python-single-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}md/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	inherit vcs-snapshot
	COMMIT="8a021f5e8b1d508f356f4419d360bd9dfb7fec2c"
	SRC_URI="https://github.com/${PN}md/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda doc examples +fftw +hdf5 test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>dev-python/cython-0.22[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	dev-libs/boost:=[mpi]
	hdf5? ( sci-libs/hdf5:=[cxx] )"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base )"

DOCS=( AUTHORS NEWS README ChangeLog )

PATCHES=( "${FILESDIR}"/1056.patch )

src_prepare() {
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DWITH_TESTS=$(usex test)
		-DWITH_SCAFACOS=ON
		-DINSTALL_PYPRESSO=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_FFTW3=$(usex !fftw)
		-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=$(usex !hdf5)
		-DCMAKE_SKIP_RPATH=YES
		-DLIBDIR=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doxygen
	[[ ${PV} = 9999 ]] && use doc && cmake-utils_src_make ug dg tutorials
}

src_install() {
	local i docdir="${S}"

	cmake-utils_src_install

	insinto /usr/share/${PN}/
	doins ${CMAKE_BUILD_DIR}/myconfig-sample.hpp

	save_config ${CMAKE_BUILD_DIR}/src/core/myconfig-final.hpp

	if use doc; then
		[[ ${PV} = 9999 ]] && docdir="${CMAKE_BUILD_DIR}"
		newdoc "${docdir}"/doc/dg/dg.pdf developer_guide.pdf
		newdoc "${docdir}"/doc/ug/ug.pdf user_guide.pdf
		for i in "${docdir}/doc/tutorials/python"/*/[0-9]*.pdf; do
			newdoc "${i}" "tutorial_${i##*/}"
		done
		dodoc -r ${CMAKE_BUILD_DIR}/doc/doxygen/html
	fi

	if use examples; then
		insinto "/usr/share/${PN}/examples/"
		doins -r samples/python/.
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
