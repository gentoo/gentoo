# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm llvm.org toolchain-funcs

DESCRIPTION="A static clangformat library patched for IDE use"
HOMEPAGE="https://www.qt.io/blog/2019/04/17/clangformat-plugin-qt-creator-4-9"
LLVM_COMPONENTS=( clang )

llvm.org_set_globals

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="~sys-devel/llvm-${PV}:${SLOT}=[debug=]"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

PATCHES=( "${FILESDIR}/clang-qtcreator-compat.patch" )

pkg_setup() {
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
}

src_unpack() {
	llvm.org_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
	)

	if [[ -n ${EPREFIX} ]]; then
		mycmakeargs+=(
			-DGCC_INSTALL_PREFIX="${EPREFIX}/usr"
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure
}

src_compile() {
	cmake_src_compile libclangFormat.a
}

src_install() {
	into usr/lib/llvm/${SLOT}
	newlib.a "${BUILD_DIR}/$(get_libdir)/libclangFormat.a" libclangFormatIDE.a
	insinto usr/lib/llvm/${SLOT}/include/clang/Format
	newins "${S}/include/clang/Format/Format.h" FormatIDE.h
}
