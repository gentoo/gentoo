# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Biochemical Algorithms Library"
HOMEPAGE="http://www.ball-project.org/"
SRC_URI="http://www.ball-project.org/Downloads/v${PV}/BALL-${PV}.tar.xz"

SLOT="0"
LICENSE="LGPL-2 GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda mpi +python sql test +threads"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
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
	sql? ( dev-qt/qtsql:4 )"
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
	"${FILESDIR}"/${P}-fix-python-bindings.patch
	"${FILESDIR}"/${P}-std-namespace-isnan.patch
	"${FILESDIR}"/${P}-struct-swap-attribute.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DUSE_FFTW_THREADS=$(usex threads)
		-DMT_ENABLE_CUDA=$(usex cuda)
		-DMT_ENABLE_MPI=$(usex mpi)
		-DBALL_HAS_QTSQL=$(usex sql)
		-DBALL_PYTHON_SUPPORT=$(usex python)
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
