# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake-multilib flag-o-matic llvm llvm.org python-any-r1 \
	toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="+clang +libcxxabi static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

RDEPEND="
	libcxxabi? (
		~sys-libs/libcxxabi-${PV}[static-libs?,${MULTILIB_USEDEP}]
	)
	!libcxxabi? ( >=sys-devel/gcc-4.7:=[cxx] )
"
# llvm-6 for new lit options
# clang-3.9.0 installs necessary target symlinks unconditionally
# which removes the need for MULTILIB_USEDEP
DEPEND="
	${RDEPEND}
	>=sys-devel/llvm-6
"
BDEPEND="
	clang? (
		sys-devel/clang
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		>=dev-util/cmake-3.16
		sys-devel/gdb[python]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( runtimes libcxx{,abi} llvm/{cmake,utils/llvm-lit} cmake )
LLVM_PATCHSET=9999-1
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# Darwin Prefix builds do not have llvm installed yet, so rely on
	# bootstrap-prefix to set the appropriate path vars to LLVM instead
	# of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version dev-lang/llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup

	if ! use libcxxabi && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
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
		cxxabi=system-libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/c++/v1"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	if use clang && ! tc-is-clang; then
		# Only do this conditionally to allow overriding with
		# e.g. CC=clang-13 in case of breakage
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	# link against compiler-rt instead of libgcc if this is what clang does
	local want_compiler_rt=OFF
	if tc-is-clang; then
		local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			${LDFLAGS} -print-libgcc-file-name)
		if [[ ${compiler_rt} == *libclang_rt* ]]; then
			want_compiler_rt=ON
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
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES=libcxx
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_USE_COMPILER_RT=${want_compiler_rt}
	)

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	if [[ ${CHOST} != *-darwin* ]] ; then
		gen_shared_ldscript
		use static-libs && gen_static_ldscript
	fi
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-cxx
}

multilib_src_install() {
	cmake_src_install
	# since we've replaced libc++.{a,so} with ldscripts, now we have to
	# install the extra symlinks
	if [[ ${CHOST} != *-darwin* ]] ; then
		dolib.so lib/libc++_shared.so
		use static-libs && dolib.a lib/libc++_static.a
	fi
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
	# Move it first.
	mv lib/libc++{,_static}.a || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps=(
		libc++_static.a
		$(usex libcxxabi libc++abi.a libsupc++.a)
	)
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=( libpthread.a libdl.a )

	gen_ldscript "${deps[*]}" > lib/libc++.a || die
}

gen_shared_ldscript() {
	# Move it first.
	mv lib/libc++{,_shared}.so || die
	local deps=(
		libc++_shared.so
		# libsupc++ doesn't have a shared version
		$(usex libcxxabi libc++abi.so libsupc++.a)
	)

	gen_ldscript "${deps[*]}" > lib/libc++.so || die
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
