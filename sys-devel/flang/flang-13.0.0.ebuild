# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib llvm python-single-r1

DESCRIPTION="Flang is a ground-up implementation of a Fortran front end written in modern C++"
HOMEPAGE=" https://github.com/llvm/llvm-project/tree/main/flang
		http://flang.llvm.org/docs/"
SRC_URI="https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/llvm-project-${PV}.src.tar.xz
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-Link-against-libclang-cpp.so.patch -> flang-Link-against-libclang-cpp.so.patch
	https://src.fedoraproject.org/rpms/flang/raw/rawhide/f/0001-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch -> flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch
"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="13"
IUSE="doc test +clang"
KEYWORDS="~amd64"

DEPEND="
	>=sys-devel/clang-13.0.0:13=[static-analyzer,${MULTILIB_USEDEP}]
	sys-devel/llvm:13=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

BDEPEND="
	doc? (
		dev-python/sphinx
		app-doc/doxygen[dot]
	)
	test? (
		dev-python/lit
	)
	sys-devel/mlir:13=
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

LLVM_MAX_SLOT=13

pkg_setup() {
	use system-llvm && llvm_pkg_setup
	if use clang ; then
		export CC=clang
		export CXX=clang++
		export AR=llvm-ar
		export LD=lld
		export RANLIB=llvm-ranlib
		export NM=llvm-nm
	fi

}

src_unpack() {
	unpack llvm-project-${PV}.src.tar.xz
	mv "${WORKDIR}/llvm-project-${PV}.src/flang" "${WORKDIR}/${P}" || die
}

src_prepare() {
	eapply -p2 "${DISTDIR}/flang-Link-against-libclang-cpp.so.patch"
	eapply -p2 "${DISTDIR}/flang-PATCH-flang-Disable-use-of-sphinx_markdown_tables.patch"
	eapply_user
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-GNinja
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DMLIR_TABLEGEN_EXE="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/mlir-tblgen"
		-DCMAKE_BUILD_TYPE=Release
		-DCLANG_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/clang/"
		-DMLIR_DIR="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/mlir/"
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DLLVM_LINK_LLVM_DYLIB:BOOL=ON
		-DLLVM_ENABLE_THREADS=ON

		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm/"
		-Wno-dev
		)
		use clang &&  mycmakeargs+=(
			-DLLVM_ENABLE_LLD=ON
		)
		use doc &&  mycmakeargs+=(
			-DLLVM_ENABLE_SPHINX:BOOL=ON
			-DLLVM_ENABLE_DOXYGEN=ON
			-DFLANG_INCLUDE_DOCS=ON
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DSPHINX_EXECUTABLE=/usr/bin/sphinx-build
		)
		use test && mycmakeargs+=(
				-DLLVM_BUILD_TESTS=ON
				-DLLVM_EXTERNAL_LIT="${BROOT}"/usr/bin//lit
				-DPython3_EXECUTABLE="${PYTHON}"
		)
	cmake_src_configure
}

multilib_src_compile() {
	export LD_LIBRARY_PATH="${S}_build-abi_${ABI}.${ARCH}/lib:${LD_LIBRARY_PATH}"
	cmake_src_compile
	if use doc ; then
		cmake_src_compile doxygen-flang
	fi
}
