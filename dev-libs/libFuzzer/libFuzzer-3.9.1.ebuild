# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cmake-multilib flag-o-matic

MY_P="llvm-${PV}"

DESCRIPTION="A fuzzing library distributed as part of LLVM"
HOMEPAGE="http://llvm.org/docs/LibFuzzer.html"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S_ROOT="${WORKDIR}/${MY_P}.src"
S="${S_ROOT}/lib/Fuzzer"

PATCHES=(
	"${FILESDIR}"/${P}-32-bit.patch #612656
)

src_prepare() {
	cmake-utils_src_prepare
	sed -i '/CMAKE_CXX_FLAGS/d' CMakeLists.txt || die
}

multilib_src_configure() {
	append-cxxflags -std=c++11
	local mycmakeargs=(
		"-DLLVM_USE_SANITIZE_COVERAGE=ON"
		"-DLLVM_USE_SANITIZER=Address"
		"-DLIB_DIR=$(get_libdir)"
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	newlib.a libLLVMFuzzer.a libFuzzer.a
	newlib.a libLLVMFuzzerNoMain.a libFuzzerNoMain.a
}

multilib_src_install_all() {
	dodoc "${S_ROOT}/docs/LibFuzzer.rst"
}
