# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Ninja provides better scalability and cleaner verbose output, and is used
# throughout all LLVM projects.
: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
EGIT_REPO_URI="http://llvm.org/git/libcxx.git
	https://github.com/llvm-mirror/libcxx.git"
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

[[ ${PV} == 9999 ]] && SCM="git-r3" || SCM=""

inherit ${SCM} cmake-multilib python-any-r1 toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [[ ${PV} != 9999 ]] ; then
	SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
		test? ( http://llvm.org/releases/${PV}/llvm-${PV}.src.tar.xz )"
	S="${WORKDIR}/${P}.src"
	LLVM_S="${WORKDIR}/llvm-${PV}.src"
else
	SRC_URI=""
	LLVM_S="${WORKDIR}/llvm"
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="elibc_glibc elibc_musl +libcxxrt libunwind +static-libs test"
REQUIRED_USE="libunwind? ( libcxxrt )"

RDEPEND="libcxxrt? ( sys-libs/libcxxrt[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxrt? ( >=sys-devel/gcc-4.7:=[cxx] )"
# llvm-3.9.0 needed because its cmake files installation path changed, which is
# needed by libcxx
# clang-3.9.0 installs necessary target symlinks unconditionally
# which removes the need for MULTILIB_USEDEP
DEPEND="${RDEPEND}
	test? ( >=sys-devel/clang-3.9.0
		${PYTHON_DEPS} )
	app-arch/xz-utils
	>=sys-devel/llvm-3.9.0"

DOCS=( CREDITS.TXT )

PATCHES=(
	# Add link flag "-Wl,-z,defs" to avoid underlinking; this is needed in a
	# out-of-tree build.
	"${FILESDIR}/${PN}-3.9-cmake-link-flags.patch"
)

pkg_setup() {
	use test && python_setup

	if ! use libcxxrt && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
	if tc-is-gcc && [[ $(gcc-version) < 4.7 ]] ; then
		eerror "${PN} needs to be built with gcc-4.7 or later (or other"
		eerror "conformant compilers). Please use gcc-config to switch to"
		eerror "gcc-4.7 or later version."
		die
	fi
}

src_unpack() {
	[[ ${PV} != 9999 ]] && default && return

	if use test; then
		# needed for tests
		git-r3_fetch "http://llvm.org/git/llvm.git
			https://github.com/llvm-mirror/llvm.git"
	fi
	git-r3_fetch

	if use test; then
		git-r3_checkout http://llvm.org/git/llvm.git \
			"${WORKDIR}"/llvm
	fi
	git-r3_checkout
}

src_configure() {
	NATIVE_LIBDIR=$(get_libdir)
	cmake-multilib_src_configure
}

multilib_src_configure() {
	local cxxabi cxxabi_incs
	if use libcxxrt; then
		cxxabi=libcxxrt
		cxxabi_incs="${EPREFIX}/usr/include/libcxxrt"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		# LLVM_LIBDIR_SUFFIX is used to find CMake files
		# and we are happy to use the native set
		-DLLVM_LIBDIR_SUFFIX=${NATIVE_LIBDIR#lib}
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=$(usex !libunwind)
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DCMAKE_SHARED_LINKER_FLAGS=$(usex libunwind "-lunwind" "")
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_MAIN_SRC_DIR=${LLVM_S}
		)
	fi
	cmake-utils_src_configure
}

multilib_src_test() {
	local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)

	[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"
	sed -i -e "/cxx_under_test/s^\".*\"^\"${clang_path}\"^" test/lit.site.cfg || die

	cmake-utils_src_make check-libcxx
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

gen_static_ldscript() {
	local libdir=$(get_libdir)
	local cxxabi_lib=$(usex libcxxrt "libcxxrt.a" "libsupc++.a")

	# Move it first.
	mv "${ED}/usr/${libdir}/libc++.a" "${ED}/usr/${libdir}/libc++_static.a" || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="libc++_static.a ${cxxabi_lib}"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=" libpthread.a libdl.a"
	# unlike libgcc_s, libunwind is not implicitly linked
	use libunwind && deps+=" libunwind.a"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.a" || die
}

gen_shared_ldscript() {
	local libdir=$(get_libdir)
	# libsupc++ doesn't have a shared version
	local cxxabi_lib=$(usex libcxxrt "libcxxrt.so" "libsupc++.a")

	mv "${ED}/usr/${libdir}/libc++.so" "${ED}/usr/${libdir}/libc++_shared.so" || die
	local deps="libc++_shared.so ${cxxabi_lib}"
	use libunwind && deps+=" libunwind.so"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.so" || die
}

multilib_src_install() {
	cmake-utils_src_install
	gen_shared_ldscript
	use static-libs && gen_static_ldscript
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
