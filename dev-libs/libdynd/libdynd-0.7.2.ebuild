# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils cuda

# change each new libdynd version, to avoid git in tree dependency
DYND_GIT_SHA1=341d6d91931fdb04ad657d27ed740cf533fc925b

DESCRIPTION="C++ dynamic multi-dimensionnal array library with Python exposure"
HOMEPAGE="http://libdynd.org"
SRC_URI="https://github.com/libdynd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc fftw mkl test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/c-blosc:0=
	cuda? ( dev-util/nvidia-cuda-toolkit )
	fftw? ( sci-libs/fftw:3.0 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
"

DOCS=( README.md )

src_prepare() {
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
	cmake_comment_add_subdirectory examples
	# fix forced cxxflags and doc installation directory
	sed -e 's|-O3 -fomit-frame-pointer||' \
		-e 's|-Werror||g' \
		-e "s|docs DESTINATION docs|docs/html DESTINATION share/doc/${PF}|" \
		-i CMakeLists.txt || die
	# don't install test exec
	sed -e 's|install(TARGETS test_libdynd||' \
		-e 's|RUNTIME DESTINATION bin)||' \
		-i tests/CMakeLists.txt || die
	# remove the version mangling from git stuff it requires a git clone
	# rather force set it a configure time
	sed -e '/GetGitRev/d' \
		-e '/get_git_/d' \
		-e '/git_describe/d' \
		-e '/dirty/d' \
		-i CMakeLists.txt || die
	# not tested
	if use mkl; then
		sed -e "s|/opt/intel/.*|$(ls -1d ${EPREFIX}/opt/intel/compilers*)|" \
			-i tests/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DDYND_GIT_SHA1="${DYND_GIT_SHA1}"
		-DDYND_VERSION_STRING="v${PV}"
		-DDYND_INSTALL_LIB=ON
		-DDYND_SHARED_LIB=ON
		-DDYND_BUILD_BENCHMARKS=OFF
		-DDYND_BUILD_DOCS="$(usex doc)"
		-DDYND_BUILD_PLUGIN="$(usex mkl)"
		-DDYND_BUILD_TESTS="$(usex test)"
		-DDYND_CUDA="$(usex cuda)"
		-DDYND_FFTW="$(usex fftw)"
		-DFFTW_PATH="${EPREFIX}/usr/include"
	)
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./tests/test_libdynd || die
}
