# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ball/ball-1.4.2.ebuild,v 1.3 2015/05/05 08:46:50 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Biochemical Algorithms Library"
HOMEPAGE="http://www.ball-project.org/"
SRC_URI="http://www.ball-project.org/Downloads/v${PV}/BALL-${PV}.tar.xz"

SLOT="0"
LICENSE="LGPL-2 GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda mpi +python sql test +threads +webkit"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qttest:4
	dev-qt/qtwebkit:4
	media-libs/glew
	sci-libs/fftw:3.0[threads?]
	sci-libs/gsl
	sci-libs/libsvm
	sci-mathematics/lpsolve
	virtual/opengl
	x11-libs/libX11
	cuda? ( dev-util/nvidia-cuda-toolkit )
	mpi? ( virtual/mpi )
	python? ( ${PYTHON_DEPS} )
	sql? ( dev-qt/qtsql:4 )
	webkit? ( dev-qt/qtwebkit:4 )"
DEPEND="${RDEPEND}
	dev-python/sip
	sys-devel/bison
	virtual/yacc"

S="${WORKDIR}"/BALL-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-multilib.patch
	"${FILESDIR}"/${PN}-1.4.1-missing-signed.patch
	"${FILESDIR}"/${P}-PDBFile-Fix-compilation-with-gcc-4.8.patch
	"${FILESDIR}"/${P}-QT4_EXTRACT_OPTIONS-CMake-macro-changed-in-CMake-2.8.patch
	"${FILESDIR}"/${PN}-1.4.1-BondOrder.xml.patch
	"${FILESDIR}"/${P}-Fix-compilation-of-sipModularWidget.patch
	"${FILESDIR}"/${P}-underlinking.patch
	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use threads FFTW_THREADS)
		$(cmake-utils_use cuda MT_ENABLE_CUDA)
		$(cmake-utils_use mpi MT_ENABLE_MPI)
		$(cmake-utils_use sql BALL_HAS_QTSQL)
		$(cmake-utils_use_use webkit USE_QTWEBKIT)
		$(cmake-utils_use python BALL_PYTHON_SUPPORT)
	)
	cmake-utils_src_configure
	local i
	for i in "${S}"/data/*; do
		ln -sf "${i}" "${BUILD_DIR}"/source/TEST/ || die
		ln -sf "${i}" "${S}"/source/TEST/ || die
	done
}

src_compile() {
	cmake-utils_src_compile
	use test && cmake-utils_src_make build_tests
}
