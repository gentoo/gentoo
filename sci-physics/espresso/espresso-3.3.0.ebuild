# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1 savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://espressomd.org"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/espressomd.git"
	EGIT_BRANCH="master"
	AUTOTOOLS_AUTORECONF=1
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="mirror://nongnu/${PN}md/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="X cuda doc examples +fftw mpi packages python test -tk"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	tk? ( X )"

RESTRICT="tk? ( test )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	dev-lang/tcl:0=
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	mpi? ( virtual/mpi )
	packages? ( dev-tcltk/tcllib )
	tk? ( >=dev-lang/tk-8.4.18-r1:0= )
	X? ( x11-libs/libX11 )"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base )"

DOCS=( AUTHORS NEWS README ChangeLog )
PATCHES=( "${FILESDIR}/${P}-cython-0.22.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	use cuda && cuda_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	myeconfargs=(
		$(use_with fftw) \
		$(use_with cuda) \
		$(use_with python python-interface) \
		$(use_with mpi) \
		$(use_with tk) \
		$(use_with X x)
	)
	CXX=$(usex mpi "mpic++" "$(tc-getCXX)") autotools-utils_src_configure
	restore_config myconfig.hpp
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile doxygen
	[[ ${PV} = 9999 ]] && use doc && autotools-utils_src_compile ug dg tutorials
}

src_install() {
	local i

	autotools-utils_src_install

	insinto /usr/share/${PN}
	doins ${AUTOTOOLS_BUILD_DIR}/myconfig-sample.hpp

	save_config ${AUTOTOOLS_BUILD_DIR}/src/core/myconfig-final.hpp

	if use doc; then
		if [[ ${PV} = 9999 ]] ; then
			newdoc "${AUTOTOOLS_BUILD_DIR}"/doc/dg/dg.pdf developer_guide.pdf
			newdoc "${AUTOTOOLS_BUILD_DIR}"/doc/ug/ug.pdf user_guide.pdf
			for i in "${AUTOTOOLS_BUILD_DIR}"/doc/tutorials/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		else
			newdoc "${S}"/doc/ug/ug.pdf user_guide.pdf
			for i in "${S}"/doc/tutorials/*/[0-9]*.pdf; do
				newdoc "${i}" "tutorial_${i##*/}"
			done
		fi
		dohtml -r "${AUTOTOOLS_BUILD_DIR}"/doc/doxygen/html/*
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
