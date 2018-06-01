# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
COMMIT=e80b5e2021a72faa36bf9e35207998d4590f2cf4
inherit cmake-utils python-single-r1

DESCRIPTION="Biochemical Algorithms Library"
HOMEPAGE="https://github.com/BALL-Project/ball"
SRC_URI="https://github.com/BALL-Project/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2 fftw? ( GPL-3 ) openbabel? ( GPL-3 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc +fftw +gui lpsolve mpi openbabel +python svm test threads webengine"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	threads? ( fftw )
	webengine? ( gui )
"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	media-libs/glew:0=
	virtual/opengl
	x11-libs/libX11
	cuda? ( dev-util/nvidia-cuda-toolkit )
	fftw? ( sci-libs/fftw:3.0=[threads?] )
	gui? (
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qttest:5
		dev-qt/qtwidgets:5
	)
	lpsolve? ( sci-mathematics/lpsolve )
	mpi? ( virtual/mpi )
	openbabel? ( sci-chemistry/openbabel:= )
	python? ( ${PYTHON_DEPS} )
	svm? ( sci-libs/libsvm:= )
	webengine? (
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
	)
"
DEPEND="${RDEPEND}
	sys-devel/bison
	virtual/yacc
	doc? ( app-doc/doxygen[dot] )
	gui? ( dev-qt/linguist-tools:5 )
	python? ( dev-python/sip )
"

S="${WORKDIR}"/${PN}-${COMMIT}

PATCHES=( "${FILESDIR}"/${PN}-1.5.0-gnuinstalldirs.patch )

RESTRICT="test"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DUPDATE_TRANSLATIONS=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DUSE_CUDA=$(usex cuda)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_FFTW=$(usex !fftw)
		-DUSE_LPSOLVE=$(usex lpsolve)
		-DUSE_MPI=$(usex mpi)
		-DREQUIRE_MPI=$(usex mpi)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenBabel2=$(usex !openbabel)
		-DBALL_PYTHON_SUPPORT=$(usex python)
		-DBALL_HAS_VIEW=$(usex gui)
		-DUSE_LIBSVM=$(usex svm)
		-DUSE_FFTW_THREADS=$(usex threads)
		-DUSE_QTWEBENGINE=$(usex webengine)
	)

	if use fftw || use openbabel; then
		mycmakeargs+=( -DBALL_LICENSE=GPL )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use test && cmake-utils_src_make build_tests
}
