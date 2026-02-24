# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib crossdev flag-o-matic llvm.org llvm-utils
inherit python-any-r1 toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
IUSE="+clang +libcxxabi +static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

RDEPEND="
	libcxxabi? (
		~llvm-runtimes/libcxxabi-${PV}[static-libs?,${MULTILIB_USEDEP}]
	)
	!libcxxabi? ( >=sys-devel/gcc-4.7:=[cxx] )
"
DEPEND="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? (
		llvm-core/clang:${LLVM_MAJOR}
		llvm-core/clang-linker-config:${LLVM_MAJOR}
		llvm-runtimes/clang-rtlib-config:${LLVM_MAJOR}
		llvm-runtimes/clang-unwindlib-config:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		dev-debug/gdb[python]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=(
	runtimes libcxx{,abi} libc llvm/{cmake,utils/llvm-lit} cmake
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
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
	local install_prefix=${EPREFIX}
	is_crosspkg && install_prefix+=/usr/${CTARGET}

	# note: we need to do this before multilib kicks in since it will
	# alter the CHOST
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=system-libcxxabi
		cxxabi_incs="${install_prefix}/usr/include/c++/v1"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# Workaround for bgo #961153.
	# TODO: Fix the multilib.eclass, so it sets CTARGET properly.
	if ! is_crosspkg; then
		export CTARGET=${CHOST}
	fi

	if use clang; then
		llvm_prepend_path -b "${LLVM_MAJOR}"
		local -x CC=${CTARGET}-clang-${LLVM_MAJOR}
		local -x CXX=${CTARGET}-clang++-${LLVM_MAJOR}
		strip-unsupported-flags

		# The full clang configuration might not be ready yet. Use the partial
		# configuration of components that libunwind depends on.
		local flags=(
			--config="${ESYSROOT}"/etc/clang/"${LLVM_MAJOR}"/gentoo-{rtlib,unwindlib,linker}.cfg
		)
		local -x CFLAGS="${CFLAGS} ${flags[@]}"
		local -x CXXFLAGS="${CXXFLAGS} ${flags[@]}"
		local -x LDFLAGS="${LDFLAGS} ${flags[@]}"
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local nostdlib_flags=( -nostdlib++ )
	if ! test_compiler && test_compiler "${nostdlib_flags[@]}"; then
		local -x LDFLAGS="${LDFLAGS} ${nort_flags[*]}"
		ewarn "${CXX} seems to lack runtime, trying with ${nort_flags[*]}"
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DCMAKE_CXX_COMPILER_TARGET="${CTARGET}"
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
		-DLIBCXX_HAS_MUSL_LIBC=$(llvm_cmake_use_musl)
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_INSTALL_MODULES=ON
		-DLIBCXX_USE_COMPILER_RT=${use_compiler_rt}
		# this is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF
	)
	if ! has_version -b sys-devel/gcc; then
		# Since this package is merged before llvm-runtimes/clang-stdlib-config,
		# clang will attempt to use libstdc++ for the C++ compiler check, and will
		# fail if it is missing.
		mycmakeargs+=( -DCMAKE_CXX_COMPILER_WORKS=1 )
	fi
	if is_crosspkg; then
		# Needed to target built libc headers
		local -x CFLAGS="${CFLAGS} -isystem ${ESYSROOT}/usr/${CTARGET}/usr/include"
		mycmakeargs+=(
			# Without this, the compiler will compile a test program
			# and fail due to no builtins.
			-DCMAKE_C_COMPILER_WORKS=1
			-DCMAKE_CXX_COMPILER_WORKS=1
			# Install inside the cross sysroot.
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/${CTARGET}/usr"
		)
	fi
	if use test; then
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
		local libdir=$(get_libdir)
		gen_shared_ldscript
		use static-libs && gen_static_ldscript
	fi
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	# https://github.com/llvm/llvm-project/issues/153940
	local -x LIT_XFAIL="libcxx/gdb/gdb_pretty_printer_test.sh.cpp"
	cmake_build libcxx-test-suite-install-cxx
	if [[ ${CHOST} != *-darwin* ]] ; then
		local libdir=$(get_libdir)
		cp "${BUILD_DIR}"/{,libcxx/test-suite-install/}"${libdir}"/libc++_shared.so || die
		if use static-libs; then
			cp "${BUILD_DIR}"/{,libcxx/test-suite-install/}"${libdir}"/libc++_static.a || die
		fi
	fi
	cmake_build check-cxx
}

multilib_src_install() {
	cmake_src_install
	# since we've replaced libc++.{a,so} with ldscripts, now we have to
	# install the extra symlinks
	if [[ ${CHOST} != *-darwin* ]] ; then
		local libdir=$(get_libdir)
		is_crosspkg && into /usr/${CTARGET}/usr
		dolib.so "${libdir}"/libc++_shared.so
		use static-libs && dolib.a "${libdir}"/libc++_static.a
	fi

	local install_prefix=
	is_crosspkg && install_prefix=/usr/${CTARGET}
	insinto "${install_prefix}/usr/share/libc++/gdb"
	doins ../libcxx/utils/gdb/libcxx/printers.py

	local lib_version=$(sed -n -e 's/^LIBCXX_LIBRARY_VERSION:STRING=//p' CMakeCache.txt || die)
	[[ -n ${lib_version} ]] || die "Could not determine LIBCXX_LIBRARY_VERSION from CMakeCache.txt"

	insinto "${install_prefix}/usr/share/gdb/auto-load/usr/$(get_libdir)"
	newins - "libc++.so.${lib_version}-gdb.py" <<-EOF
		__import__("sys").path.insert(0, "${EPREFIX}/usr/share/libc++/gdb")
		__import__("printers").register_libcxx_printer_loader()
	EOF
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
	mv "${libdir}"/libc++{,_static}.a || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps=(
		libc++_static.a
		$(usex libcxxabi libc++abi.a libsupc++.a)
	)
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=( libpthread.a libdl.a )

	gen_ldscript "${deps[*]}" > "${libdir}"/libc++.a || die
}

gen_shared_ldscript() {
	# Move it first.
	mv "${libdir}"/libc++{,_shared}.so || die
	local deps=(
		libc++_shared.so
		# libsupc++ doesn't have a shared version
		$(usex libcxxabi libc++abi.so libsupc++.a)
	)

	gen_ldscript "${deps[*]}" > "${libdir}"/libc++.so || die
}
