# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{6..9} )
inherit cmake-multilib llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"
LLVM_COMPONENTS=( libcxx{,abi} llvm/{cmake/modules,utils/llvm-lit} )
llvm.org_set_globals

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="elibc_glibc elibc_musl +libcxxabi +libunwind +static-libs test"
REQUIRED_USE="libunwind? ( libcxxabi )"
RESTRICT="!test? ( test )"

RDEPEND="
	libcxxabi? ( ~sys-libs/libcxxabi-${PV}[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxabi? ( >=sys-devel/gcc-4.7:=[cxx] )"
# llvm-6 for new lit options
# clang-3.9.0 installs necessary target symlinks unconditionally
# which removes the need for MULTILIB_USEDEP
DEPEND="${RDEPEND}
	>=sys-devel/llvm-6"
BDEPEND="
	test? (
		>=dev-util/cmake-3.16
		>=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)"

DOCS=( CREDITS.TXT )

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup

	if ! use libcxxabi && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
}

src_prepare() {
	# Add link flag "-Wl,-z,defs" to avoid underlinking; this is needed in a
	# out-of-tree build.
	eapply "${FILESDIR}/${PN}-3.9-cmake-link-flags.patch"

	llvm.org_src_prepare
}

test_compiler() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c++ - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	# note: we need to do this before multilib kicks in since it will
	# alter the CHOST
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/libcxxabi"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# we want -lgcc_s for unwinder, and for compiler runtime when using
	# gcc, clang with gcc runtime (or any unknown compiler)
	local extra_libs=() want_gcc_s=ON want_compiler_rt=OFF
	if use libunwind; then
		# work-around missing -lunwind upstream
		extra_libs+=( -lunwind )
		# if we're using libunwind and clang with compiler-rt, we want
		# to link to compiler-rt instead of -lgcc_s
		if tc-is-clang; then
			local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			   ${LDFLAGS} -print-libgcc-file-name)
			if [[ ${compiler_rt} == *libclang_rt* ]]; then
				want_gcc_s=OFF
				want_compiler_rt=ON
				extra_libs+=( "${compiler_rt}" )
			fi
		fi
	fi

	# bootstrap: cmake is unhappy if compiler can't link to stdlib
	local nolib_flags=( -nodefaultlibs -lc )
	if ! test_compiler; then
		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CXX} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=${want_gcc_s}
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_USE_COMPILER_RT=${want_compiler_rt}
		-DCMAKE_SHARED_LINKER_FLAGS="${extra_libs[*]} ${LDFLAGS}"
	)

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags);--param=cxx_under_test=${clang_path}"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-cxx
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
	local cxxabi_lib=$(usex libcxxabi "libc++abi.a" "libsupc++.a")

	# Move it first.
	mv "${ED}/usr/${libdir}/libc++.a" "${ED}/usr/${libdir}/libc++_static.a" || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="libc++_static.a ${cxxabi_lib} $(usex libunwind libunwind.a libgcc_eh.a)"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=" libpthread.a libdl.a"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.a" || die
}

gen_shared_ldscript() {
	local libdir=$(get_libdir)
	# libsupc++ doesn't have a shared version
	local cxxabi_lib=$(usex libcxxabi "libc++abi.so" "libsupc++.a")

	mv "${ED}/usr/${libdir}/libc++.so" "${ED}/usr/${libdir}/libc++_shared.so" || die
	local deps="libc++_shared.so ${cxxabi_lib} $(usex libunwind libunwind.so libgcc_s.so)"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.so" || die
}

multilib_src_install() {
	cmake_src_install
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
