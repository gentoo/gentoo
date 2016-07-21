# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils python-single-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/espressomd/espresso.git https://github.com/espressomd/espresso.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="mirror://nongnu/${PN}md/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda doc examples +fftw +hdf5 packages python test -tk"

REQUIRED_USE=" python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		>dev-python/cython-0.22[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	dev-lang/tcl:0=
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	dev-libs/boost:=[mpi]
	virtual/mpi
	hdf5? ( sci-libs/hdf5 )
	packages? ( dev-tcltk/tcllib )
	tk? ( >=dev-lang/tk-8.4.18-r1:0= )"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base )"

DOCS=( AUTHORS NEWS README ChangeLog )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DWITH_PYTHON=$(usex python)
		-DWITH_TESTS=$(usex test)
		-DWITH_H5MD=$(usex hdf5)
		-DCMAKE_DISABLE_FIND_PACKAGE_FFTW3=$(usex !fftw)
		-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=$(usex !hdf5)
		-DCMAKE_SKIP_RPATH=YES
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doxygen
	[[ ${PV} = 9999 ]] && use doc && cmake-utils_src_make ug dg tutorials
}

src_install() {
	local i

	#https://github.com/espressomd/espresso/issues/733
	#cmake-utils_src_install
	dobin ${CMAKE_BUILD_DIR}/Espresso
	dolib.so "${CMAKE_BUILD_DIR}"/src/core/{,*}/lib*.so
	if use python; then
		insinto $(python_get_sitedir)/${PN}md
		doins -r "${CMAKE_BUILD_DIR}"/src/python/espressomd
	fi

	insinto /usr/share/${PN}/
	doins ${CMAKE_BUILD_DIR}/myconfig-sample.hpp

	save_config ${CMAKE_BUILD_DIR}/src/core/myconfig-final.hpp

	if use doc; then
		if [[ ${PV} = 9999 ]] ; then
			newdoc ${CMAKE_BUILD_DIR}/doc/dg/dg.pdf developer_guide.pdf
			newdoc ${CMAKE_BUILD_DIR}/doc/ug/ug.pdf user_guide.pdf
			for i in ${CMAKE_BUILD_DIR}/doc/tutorials/*/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		else
			newdoc "${S}"/doc/ug/ug.pdf user_guide.pdf
			for i in "${S}"/doc/tutorials/*/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		fi
		dodoc -r ${CMAKE_BUILD_DIR}/doc/doxygen/html
	fi

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins -r samples/*
	fi

	if use packages; then
		insinto /usr/share/${PN}/packages
		doins -r packages/*
	fi
}

pkg_postinst() {
	echo
	elog "Please read and cite:"
	elog "ESPResSo, Comput. Phys. Commun. 174(9) ,704, 2006."
	elog "http://dx.doi.org/10.1016/j.cpc.2005.10.005"
	echo
	elog "If you need more features, change"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
	elog "and reemerge with USE=savedconfig"
	echo
	elog "For a full feature list see:"
	elog "/usr/share/${PN}/myconfig-sample.h"
	echo
}
