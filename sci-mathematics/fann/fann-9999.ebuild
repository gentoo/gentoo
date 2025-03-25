# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 toolchain-funcs

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="https://leenissen.dk"
EGIT_REPO_URI="https://github.com/libfann/fann"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
)

src_prepare() {
	cmake_src_prepare

	if use !test; then
		sed -i '/ADD_SUBDIRECTORY( tests )/d' CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		# https://bugs.gentoo.org/863050
		-DPKGCONFIG_INSTALL_DIR="${EPREFIX}/$(get_libdir)/pkgconfig"
	)
	cmake_src_configure
}

src_test() {
	cd examples || die 'fails to enter examples directory'
	LD_LIBRARY_PATH="${BUILD_DIR}/src" GCC="$(tc-getCC) ${CFLAGS} -I../src/include -L${BUILD_DIR}/src" emake -e runtest
	emake clean
}

src_install() {
	cmake_src_install
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
