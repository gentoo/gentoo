# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils cuda eutils git-r3 multilib toolchain-funcs

DESCRIPTION="Fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="http://www.cs.ubc.ca/research/flann/"
SRC_URI="test? ( https://dev.gentoo.org/~bicatali/distfiles/${PN}-1.8.4-testdata.tar.xz )"
EGIT_REPO_URI="https://github.com/mariusmuja/flann.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
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

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp ; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
}

src_unpack() {
	default
	git-r3_src_unpack
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
