# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic git-r3 multilib-minimal \
	python-single-r1 toolchain-funcs pax-utils

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/clang.git
	https://github.com/llvm-mirror/clang.git"

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS=""
IUSE="debug default-compiler-rt default-libcxx +doc multitarget python
	+static-analyzer test xml elibc_musl kernel_FreeBSD ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	~sys-devel/llvm-${PV}:=[debug=,${LLVM_TARGET_USEDEPS// /,},${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	!<sys-devel/llvm-${PV}
	${PYTHON_DEPS}"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/lit[${PYTHON_USEDEP}] )
	xml? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
PDEPEND="
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? ( sys-libs/compiler-rt )
	default-libcxx? ( sys-libs/libcxx )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )
	multitarget? ( ${ALL_LLVM_TARGETS[*]} )"

# Multilib notes:
# 1. ABI_* flags control ABIs libclang* is built for only.
# 2. clang is always capable of compiling code for all ABIs for enabled
#    target. However, you will need appropriate crt* files (installed
#    e.g. by sys-devel/gcc and sys-libs/glibc).
# 3. ${CHOST}-clang wrappers are always installed for all ABIs included
#    in the current profile (i.e. alike supported by sys-devel/gcc).
#
# Therefore: use sys-devel/clang[${MULTILIB_USEDEP}] only if you need
# multilib clang* libraries (not runtime, not wrappers).

pkg_pretend() {
	local build_size=650

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend

	python-single-r1_pkg_setup
}

src_unpack() {
	git-r3_fetch "http://llvm.org/git/clang-tools-extra.git
		https://github.com/llvm-mirror/clang-tools-extra.git"
	if use test; then
		# needed for patched gtest
		git-r3_fetch "http://llvm.org/git/llvm.git
			https://github.com/llvm-mirror/llvm.git"
	fi
	git-r3_fetch

	git-r3_checkout http://llvm.org/git/clang-tools-extra.git \
		"${S}"/tools/clang/tools/extra
	if use test; then
		git-r3_checkout http://llvm.org/git/llvm.git \
			"${WORKDIR}"/llvm
	fi
	git-r3_checkout
}

src_prepare() {
	python_setup

	# support overriding clang runtime install directory
	eapply "${FILESDIR}"/9999/0005-cmake-Supporting-overriding-runtime-libdir-via-CLANG.patch
	# support overriding LLVMgold.so plugin directory
	eapply "${FILESDIR}"/9999/0006-cmake-Add-CLANG_GOLD_LIBDIR_SUFFIX-to-specify-loc-of.patch
	# fix stand-alone doc build
	eapply "${FILESDIR}"/9999/0007-cmake-Support-stand-alone-Sphinx-doxygen-doc-build.patch

	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		# install clang runtime straight into /usr/lib
		-DCLANG_LIBDIR_SUFFIX=""
		# specify host's binutils gold plugin path
		-DCLANG_GOLD_LIBDIR_SUFFIX="${NATIVE_LIBDIR#lib}"

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		# TODO: get them properly conditional
		#-DLLVM_BUILD_TESTS=$(usex test)

		# these are not propagated reliably, so redefine them
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
		# libgomp support fails to find headers without explicit -I
		# furthermore, it provides only syntax checking
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		# override default stdlib and rtlib
		-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
		-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	fi

	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
		)
		use doc && mycmakeargs+=(
			-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
	else
		mycmakeargs+=(
			-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_BUILD=OFF
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

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-clang
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Apply CHOST and version suffix to clang tools
	local clang_version=4.0
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local abi i

	# cmake gives us:
	# - clang-X.Y
	# - clang -> clang-X.Y
	# - clang++, clang-cl, clang-cpp -> clang
	# we want to have:
	# - clang-X.Y
	# - clang++-X.Y, clang-cl-X.Y, clang-cpp-X.Y -> clang-X.Y
	# - clang, clang++, clang-cl, clang-cpp -> clang*-X.Y
	# also in CHOST variant
	for i in "${clang_tools[@]:1}"; do
		rm "${ED%/}/usr/bin/${i}" || die
		dosym "clang-${clang_version}" "/usr/bin/${i}-${clang_version}"
		dosym "${i}-${clang_version}" "/usr/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${clang_version}" \
				"/usr/bin/${abi_chost}-${i}-${clang_version}"
			dosym "${abi_chost}-${i}-${clang_version}" \
				"/usr/bin/${abi_chost}-${i}"
		done
	done

	# Remove unnecessary headers on FreeBSD, bug #417171
	if use kernel_FreeBSD; then
		rm "${ED}"usr/lib/clang/${PV}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	if use python ; then
		pushd bindings/python/clang >/dev/null || die

		python_moduleinto clang
		python_domodule *.py

		popd >/dev/null || die
	fi

	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"usr/share/scan-view
	fi
}
