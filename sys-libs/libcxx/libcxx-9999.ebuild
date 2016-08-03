# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="http://llvm.org/git/libcxx.git
	https://github.com/llvm-mirror/libcxx.git"

[ "${PV%9999}" != "${PV}" ] && SCM="git-r3" || SCM=""

inherit ${SCM} cmake-multilib toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz"
	S="${WORKDIR}/${P}.src"
else
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="elibc_glibc elibc_musl libcxxabi +libcxxrt libsupc++ libunwind +static-libs"
REQUIRED_USE="libunwind? ( || ( libcxxabi libcxxrt ) )
	^^ ( libcxxabi libcxxrt libsupc++ )"

RDEPEND="libcxxabi? ( sys-libs/libcxxabi[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	libcxxrt? ( sys-libs/libcxxrt[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	libsupc++? ( >=sys-devel/gcc-4.7:=[cxx] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

DOCS=( CREDITS.TXT )

pkg_setup() {
	if use libsupc++ && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
	if use libsupc++ ; then
		ewarn "You have disabled USE=libcxxrt. This will build ${PN} against"
		ewarn "libsupc++. Please note that this is not well supported."
		ewarn "In particular, static linking will not work."
	fi
	if tc-is-gcc && [[ $(gcc-version) < 4.7 ]] ; then
		eerror "${PN} needs to be built with gcc-4.7 or later (or other"
		eerror "conformant compilers). Please use gcc-config to switch to"
		eerror "gcc-4.7 or later version."
		die
	fi
}

multilib_src_configure() {
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/libcxxabi"
	elif use libcxxrt; then
		cxxabi=libcxxrt
		cxxabi_incs="${EPREFIX}/usr/include/libcxxrt"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_CONFIG_PATH=OFF
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=$(usex !libunwind)
	)
	cmake-utils_src_configure
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

# Usage: cxxabi
gen_static_ldscript() {
	local libdir=$(get_libdir)
	local cxxabi=$1

	# Move it first.
	mv "${ED}/usr/${libdir}/libc++.a" "${ED}/usr/${libdir}/libc++_static.a" || die

	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="${EPREFIX}/usr/${libdir}/libc++_static.a ${EPREFIX}/usr/${libdir}/${cxxabi}.a"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=" ${EPREFIX}/usr/${libdir}/libpthread.a ${EPREFIX}/usr/${libdir}/libdl.a"
	# unlike libgcc_s, libunwind is not implicitly linked
	use libunwind && deps+=" ${EPREFIX}/usr/${libdir}/libunwind.a"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.a" || die
}

# Usage: cxxabi
gen_shared_ldscript() {
	local libdir=$(get_libdir)
	local cxxabi=$1

	mv "${ED}/usr/${libdir}/libc++.so" "${ED}/usr/${libdir}/libc++_shared.so" || die
	local deps="${EPREFIX}/usr/${libdir}/libc++_shared.so ${EPREFIX}/usr/${libdir}/${cxxabi}.so"
	use libunwind && deps+=" ${EPREFIX}/usr/${libdir}/libunwind.so"
	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.so" || die
}

multilib_src_install() {
	cmake-utils_src_install
	if ! use libsupc++; then
		local cxxabi=$(usex libcxxabi libc++abi libcxxrt)
		gen_shared_ldscript ${cxxabi}
		use static-libs && gen_static_ldscript ${cxxabi}
	fi
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
