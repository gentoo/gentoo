# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-1.4.1-r2.ebuild,v 1.8 2015/08/07 09:43:37 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=true

inherit cmake-utils distutils-r1 flag-o-matic multilib toolchain-funcs

GITHUB_REV="74fcb8676de69ed04ddab8976a8b05a6caaf4d65"

DESCRIPTION="Evaluation of electrostatic properties of nanoscale biomolecular systems"
HOMEPAGE="http://www.poissonboltzmann.org/apbs/"
#SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"
SRC_URI="https://github.com/Electrostatics/apbs-pdb2pqr/archive/${GITHUB_REV}.zip -> ${P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples fast +fetk iapbs mpi openmp python tools"

REQUIRED_USE="
	iapbs? ( fetk )
	mpi? ( !python )
	python? ( tools fetk iapbs ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/maloc[mpi=]
	virtual/blas
	sys-libs/readline
	fetk? (
		sci-libs/fetk
		sci-libs/amd
		sci-libs/umfpack
		sci-libs/superlu
	)
	mpi? ( virtual/mpi )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}"/${PN}-pdb2pqr-${GITHUB_REV}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-manip.patch
	"${FILESDIR}"/${P}-python.patch
)

src_prepare() {
	cmake-utils_src_prepare
	append-cppflags $($(tc-getPKG_CONFIG) --cflags eigen3)

	sed \
		-e "s:-lblas:$($(tc-getPKG_CONFIG) --libs blas):g" \
		-e "/TOOLS_PATH/d" \
		-i CMakeLists.txt || die
	use doc && MAKEOPTS+=" -j1"
	if use python; then
		unset PATCHES || die
		cd tools/python && distutils-r1_src_prepare
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DTOOLS_PATH="${ED}"/usr
		-DSYS_LIBPATHS="${EPREFIX}"/usr/$(get_libdir)
		-DLIBRARY_INSTALL_PATH=$(get_libdir)
		-DFETK_PATH="${EPREFIX}"/usr/
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_QUIT=OFF
		$(cmake-utils_use_build doc DOC)
		$(cmake-utils_use_build tools TOOLS)
		-DENABLE_BEM=OFF
# ENABLE_BEM: Boundary element method using TABIPB
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable debug VERBOSE_DEBUG)
		$(cmake-utils_use_enable fast FAST)
		$(cmake-utils_use_enable fetk FETK)
		$(cmake-utils_use_enable mpi MPI)
		$(cmake-utils_use_enable python PYTHON)
# ENABLE_TINKER: Enable TINKER support
		$(cmake-utils_use_enable iapbs iAPBS)
# MAX_MEMORY: Set the maximum memory (in MB) to be used for a job
	)
	cmake-utils_src_configure
	if use python; then
		cd tools/python && distutils-r1_src_configure
	fi
}

src_compile(){
	cmake-utils_src_compile
	if use python; then
		append-ldflags -L"${S}"/lib
		cd tools/python && distutils-r1_src_compile
	fi
}

src_test() {
	python_export_best
	cd tests || die
	LD_LIBRARY_PATH="${S}"/lib "${PYTHON}" apbs_tester.py -l log || die
	grep -q 'FAILED' log && die "Tests failed"
}

src_install() {
	dodir /usr/bin
	cmake-utils_src_install
	local i
	for i in "${ED}"/usr/bin/*; do
		if [[ ! "${i}" =~ .*apbs$ ]]; then
			mv "${i}" "${i}-apbs" || die
		fi
	done
	if use python; then
		cd tools/python && distutils-r1_src_install
		rm -rf "${ED}"/usr/share/apbs/tools/python || die
	fi
}
