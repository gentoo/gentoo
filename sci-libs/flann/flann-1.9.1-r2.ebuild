# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils cuda flag-o-matic toolchain-funcs

DESCRIPTION="Fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="https://www.cs.ubc.ca/research/flann/"
SRC_URI="https://github.com/mariusmuja/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc examples mpi openmp octave static-libs"

BDEPEND="
	app-arch/unzip
	doc? ( dev-tex/latex2html )
"
DEPEND="
	cuda? ( >=dev-util/nvidia-cuda-toolkit-5.5 )
	mpi? (
		sci-libs/hdf5[mpi]
		dev-libs/boost:=[mpi]
	)
	!mpi? ( !sci-libs/hdf5[mpi] )
	octave? ( >=sci-mathematics/octave-3.6.4-r1 )
"
RDEPEND="${DEPEND}"
# TODO:
# readd dependencies for test suite,
# requires multiple ruby dependencies

PATCHES=(
	"${FILESDIR}"/${P}-cmake-3.11{,-1}.patch # bug 678030
	"${FILESDIR}"/${P}-cuda-9.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
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
	append-cxxflags -std=c++11

	# python bindings are split
	# off into dev-python/pyflann
	local mycmakeargs=(
		-DBUILD_C_BINDINGS=ON
		-DBUILD_PYTHON_BINDINGS=OFF
		-DPYTHON_EXECUTABLE=
		-DBUILD_CUDA_LIB=$(usex cuda)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_DOC=$(usex doc)
		-DBUILD_TESTS=OFF
		-DBUILD_MATLAB_BINDINGS=$(usex octave)
		-DUSE_MPI=$(usex mpi)
		-DUSE_OPENMP=$(usex openmp)
	)
	use cuda && mycmakeargs+=(
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS} --linker-options \"-arsch\""
	)
	use doc && mycmakeargs+=( -DDOCDIR=share/doc/${PF} )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if ! use static-libs; then
		find "${D}" -name 'lib*.a' -delete || die
	fi
}
