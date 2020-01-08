# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils cuda

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="http://dlib.net/"
SRC_URI="https://github.com/davisking/dlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas debug cuda examples gif jpeg lapack mkl png
	 sqlite static-libs test X"
RESTRICT="!test? ( test )"

# doc needs a bunch of deps not in portage

RDEPEND="
	cblas? ( virtual/cblas:= )
	cuda? ( dev-libs/cudnn:= )
	jpeg? ( virtual/jpeg:0= )
	lapack? ( virtual/lapack:= )
	mkl? ( sci-libs/mkl:= )
	png? ( media-libs/libpng:0= )
	sqlite? ( dev-db/sqlite:3= )
	X? ( x11-libs/libX11:= )
"
DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
	sed -i -e '/LICENSE.txt/d' dlib/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-DDLIB_ENABLE_ASSERTS="$(usex debug)"
		-DDLIB_ENABLE_STACK_TRACE="$(usex debug)"
		-DDLIB_GIF_SUPPORT="$(usex gif)"
		-DDLIB_JPEG_SUPPORT="$(usex jpeg)"
		-DDLIB_PNG_SUPPORT="$(usex png)"
		-DDLIB_LINK_WITH_SQLITE3="$(usex sqlite)"
		-DDLIB_NO_GUI_SUPPORT="$(usex X OFF ON)"
		-DDLIB_USE_BLAS="$(usex cblas)"
		-DDLIB_USE_CUDA="$(usex cuda)"
		-DDLIB_USE_LAPACK="$(usex lapack)"
	)
	cmake-utils_src_configure
}

src_test() {
	mkdir "${BUILD_DIR}"/dlib/test || die
	pushd "${BUILD_DIR}"/dlib/test > /dev/null || die
	cmake "${S}"/dlib/test && emake
	./dtest --runall || die
	popd > /dev/null || die
}

src_install() {
	cmake-utils_src_install
	dodoc docs/README.txt
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
}
