# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils cuda eutils multilib toolchain-funcs

DESCRIPTION="Library for performing fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="http://www.cs.ubc.ca/research/flann/"
SRC_URI="
	http://people.cs.ubc.ca/~mariusm/uploads/FLANN/${P}-src.zip
	test? ( https://dev.gentoo.org/~bicatali/distfiles/${P}-testdata.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc examples mpi openmp octave static-libs test"

RDEPEND="
	cuda? ( >=dev-util/nvidia-cuda-toolkit-5.5 )
	mpi? (
		sci-libs/hdf5[mpi]
		dev-libs/boost[mpi]
	)
	!mpi? ( !sci-libs/hdf5[mpi] )
	octave? ( >=sci-mathematics/octave-3.6.4-r1 )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-tex/latex2html )
	test? (
		dev-cpp/gtest
		cuda? ( sci-libs/hdf5 )
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-examples.patch
	"${FILESDIR}"/${P}-options.patch
	"${FILESDIR}"/${P}-CUDA_NVCC_FLAGS.patch
	"${FILESDIR}"/${P}-cuda5.5.patch
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-docdir.patch
)

S="${WORKDIR}"/${P}-src

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp ; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
}

src_prepare() {
	# bug #302621
	use mpi && export CXX=mpicxx
	# produce pure octave files
	# octave gentoo installation for .m files respected
	sed -i \
		-e 's/--mex//' \
		-e 's/\.mex/\.oct/' \
		-e '/FILES/s/${MEX_FILE}//' \
		-e 's:share/flann/octave:share/octave/site/m:' \
		-e "/CUSTOM_TARGET/a\INSTALL(FILES \${MEX_FILE} DESTINATION libexec/octave/site/oct/${CHOST})" \
		src/matlab/CMakeLists.txt || die
	use cuda && cuda_src_prepare

	cmake-utils_src_prepare
}

src_configure() {
	# python bindings are split
	local mycmakeargs=(
		-DBUILD_C_BINDINGS=ON
		-DBUILD_PYTHON_BINDINGS=OFF
		-DPYTHON_EXECUTABLE=
		-DDOCDIR=share/doc/${PF}
		$(cmake-utils_use_build cuda CUDA_LIB)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build doc)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_build octave MATLAB_BINDINGS)
		$(cmake-utils_use_use mpi)
		$(cmake-utils_use_use openmp)
	)
	use cuda && \
		mycmakeargs+=(
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS},-arsch"
		)
	cmake-utils_src_configure
}

src_test() {
	ln -s "${WORKDIR}"/testdata/* test/ || die
	# -j1 to avoid obversubscribing jobs
	LD_LIBRARY_PATH="${BUILD_DIR}/lib" \
		cmake-utils_src_compile -j1 test
}

src_install() {
	cmake-utils_src_install
	dodoc README.md
	if ! use static-libs; then
		find "${ED}" -name 'lib*.a' -exec rm -rf '{}' '+' || die
	fi
}
