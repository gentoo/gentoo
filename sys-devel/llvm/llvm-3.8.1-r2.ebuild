# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils eutils flag-o-matic multilib \
	multilib-minimal python-single-r1 toolchain-funcs pax-utils prefix

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	clang? ( http://llvm.org/releases/${PV}/compiler-rt-${PV}.src.tar.xz
		http://llvm.org/releases/${PV}/cfe-${PV}.src.tar.xz
		http://llvm.org/releases/${PV}/clang-tools-extra-${PV}.src.tar.xz )
	lldb? ( http://llvm.org/releases/${PV}/lldb-${PV}.src.tar.xz )
	!doc? ( http://dev.gentoo.org/~voyageur/distfiles/${PN}-3.8.0-manpages.tar.bz2 )"

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. ARM backend: LLVM Software Grant by ARM.
# 3. MD5 code: public-domain.
# 4. autoconf (not used): some undefined M.I.T. license.
# 5. Tests (not installed):
#  a. gtest: BSD.
#  b. YAML tests: MIT.

LICENSE="UoI-NCSA rc BSD public-domain
	multitarget? ( LLVM-Grant )"
SLOT="0/3.8.0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="clang debug default-compiler-rt default-libcxx doc gold libedit +libffi
	lldb multitarget ncurses ocaml python +sanitize +static-analyzer test xml
	video_cards_radeon elibc_musl kernel_Darwin kernel_FreeBSD"

COMMON_DEPEND="
	sys-libs/zlib:0=
	clang? (
		python? ( ${PYTHON_DEPS} )
		static-analyzer? (
			dev-lang/perl:*
			${PYTHON_DEPS}
		)
		xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	)
	gold? ( >=sys-devel/binutils-2.22:*[cxx] )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	lldb? ( dev-python/six[${PYTHON_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	ocaml? (
		>=dev-lang/ocaml-4.00.0:0=
		dev-ml/ocaml-ctypes:=
		!!<=sys-devel/llvm-3.7.0-r1[ocaml] )"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	>=sys-devel/make-3.81
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-5.1 )
	clang? ( xml? ( virtual/pkgconfig ) )
	doc? ( dev-python/sphinx )
	gold? ( sys-libs/binutils-libs )
	libffi? ( virtual/pkgconfig )
	lldb? ( dev-lang/swig )
	!!<dev-python/configparser-3.3.0.2
	ocaml? ( dev-ml/findlib
		test? ( dev-ml/ounit ) )
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	clang? ( !<=sys-devel/clang-${PV}-r99 )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"
PDEPEND="clang? ( =sys-devel/clang-${PV}-r100 )
	default-libcxx? ( sys-libs/libcxx )
	kernel_Darwin? ( =sys-libs/libcxx-${PV%.*}* )"

# pypy gives me around 1700 unresolved tests due to open file limit
# being exceeded. probably GC does not close them fast enough.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	lldb? ( clang xml )"

S=${WORKDIR}/${P/_}.src

check_space() {
	# in megs
	# !clang !debug !multitarget -O2       400
	# !clang !debug  multitarget -O2       550
	#  clang !debug !multitarget -O2       950
	#  clang !debug  multitarget -O2      1200
	# !clang  debug  multitarget -O2      5G
	#  clang !debug  multitarget -O0 -g  12G
	#  clang  debug  multitarget -O2     16G
	#  clang  debug  multitarget -O0 -g  14G

	local build_size=550
	use clang && build_size=1200

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

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
}

src_unpack() {
	default

	if use clang; then
		mv "${WORKDIR}"/cfe-${PV/_}.src "${S}"/tools/clang \
			|| die "clang source directory move failed"
		mv "${WORKDIR}"/compiler-rt-${PV/_}.src "${S}"/projects/compiler-rt \
			|| die "compiler-rt source directory move failed"
		mv "${WORKDIR}"/clang-tools-extra-${PV/_}.src "${S}"/tools/clang/tools/extra \
			|| die "clang-tools-extra source directory move failed"
	fi

	if use lldb; then
		mv "${WORKDIR}"/lldb-${PV/_}.src "${S}"/tools/lldb \
			|| die "lldb source directory move failed"
	fi
}

src_prepare() {
	python_setup

	# Make ocaml warnings non-fatal, bug #537308
	sed -e "/RUN/s/-warn-error A//" -i test/Bindings/OCaml/*ml  || die
	# Fix libdir for ocaml bindings install, bug #559134
	eapply "${FILESDIR}"/3.9.0/0001-cmake-Install-OCaml-modules-into-correct-package-loc.patch
	# Do not build/install ocaml docs with USE=-doc, bug #562008
	eapply "${FILESDIR}"/3.9.0/0002-cmake-Make-OCaml-docs-dependent-on-LLVM_BUILD_DOCS.patch

	# Make it possible to override Sphinx HTML install dirs
	# https://llvm.org/bugs/show_bug.cgi?id=23780
	eapply "${FILESDIR}"/3.9.0/0003-cmake-Support-overriding-Sphinx-HTML-doc-install-dir.patch

	# Prevent race conditions with parallel Sphinx runs
	# https://llvm.org/bugs/show_bug.cgi?id=23781
	eapply "${FILESDIR}"/3.9.0/0004-cmake-Add-an-ordering-dep-between-HTML-man-Sphinx-ta.patch

	# Prevent installing libgtest
	# https://llvm.org/bugs/show_bug.cgi?id=18341
	eapply "${FILESDIR}"/3.8.1/0005-cmake-Do-not-install-libgtest.patch

	# Allow custom cmake build types (like 'Gentoo')
	eapply "${FILESDIR}"/9999/0006-cmake-Remove-the-CMAKE_BUILD_TYPE-assertion.patch

	# Fix llvm-config for shared linking and sane flags
	# https://bugs.gentoo.org/show_bug.cgi?id=565358
	eapply "${FILESDIR}"/3.9.0/llvm-config-r1.patch

	# Restore SOVERSIONs for shared libraries
	# https://bugs.gentoo.org/show_bug.cgi?id=578392
	eapply "${FILESDIR}"/3.8.1/0008-cmake-Restore-SOVERSIONs-on-shared-libraries.patch

	# support building llvm against musl-libc
	use elibc_musl && eapply "${FILESDIR}"/9999/musl-fixes.patch

	# support "musl" as a valid environment type in llvm
	eapply "${FILESDIR}"/3.8.1/musl-env-support.patch

	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# Workaround, can be compiled with gcc on Gentoo/FreeBSD, bug #578064
	use kernel_FreeBSD && tc-is-gcc && append-cppflags "-D_GLIBCXX_USE_C99"

	if use clang; then
		# Automatically select active system GCC's libraries, bugs #406163 and #417913
		eapply "${FILESDIR}"/3.9.0/clang/gentoo-runtime-gcc-detection-v3.patch

		# Support gcc4.9 search paths
		# https://github.com/llvm-mirror/clang/commit/af4db76e059c1a3
		eapply "${FILESDIR}"/3.8.1/clang/gcc4.9-search-path.patch

		eapply "${FILESDIR}"/3.9.0/clang/darwin_prefix-include-paths.patch
		eprefixify tools/clang/lib/Frontend/InitHeaderSearch.cpp

		pushd "${S}"/tools/clang >/dev/null || die
		# be able to specify default values for -stdlib and -rtlib at build time
		eapply "${FILESDIR}"/3.8.1/clang/default-libs.patch

		# enable clang to recognize musl-libc
		eapply "${FILESDIR}"/3.8.1/clang/musl-support.patch
		popd >/dev/null || die

		sed -i -e "s^@EPREFIX@^${EPREFIX}^" \
			tools/clang/tools/scan-build/bin/scan-build || die

		# Install clang runtime into /usr/lib/clang
		# https://llvm.org/bugs/show_bug.cgi?id=23792
		eapply "${FILESDIR}"/3.9.0/clang/0001-Install-clang-runtime-into-usr-lib-without-suffix.patch
		eapply "${FILESDIR}"/3.8.1/compiler-rt/0001-cmake-Install-compiler-rt-into-usr-lib-without-suffi.patch

		# Do not force -march flags on arm platforms
		# https://bugs.gentoo.org/show_bug.cgi?id=562706
		eapply "${FILESDIR}"/3.8.1/compiler-rt/arm_march_flags.patch

		# Make it possible to override CLANG_LIBDIR_SUFFIX
		# (that is used only to find LLVMgold.so)
		# https://llvm.org/bugs/show_bug.cgi?id=23793
		eapply "${FILESDIR}"/3.9.0/clang/0002-cmake-Make-CLANG_LIBDIR_SUFFIX-overridable.patch

		# Fix git-clang-format shebang, bug #562688
		python_fix_shebang tools/clang/tools/clang-format/git-clang-format

		# Fix 'stdarg.h' file not found on Gentoo/FreeBSD, bug #578064
		# https://llvm.org/bugs/show_bug.cgi?id=26651
		eapply "${FILESDIR}"/3.8.1/compiler-rt/fbsd.patch

		# Backport abi-tag support, bug #571600
		eapply "${FILESDIR}"/3.8.1/clang/abi-tag-support-sema.patch
		eapply "${FILESDIR}"/3.8.1/clang/abi-tag-support-mangler.patch

		pushd projects/compiler-rt >/dev/null || die

		# Fix WX sections, bug #421527
		find lib/builtins -type f -name '*.S' -exec sed \
			-e '$a\\n#if defined(__linux__) && defined(__ELF__)\n.section .note.GNU-stack,"",%progbits\n#endif' \
			-i {} + || die

		popd >/dev/null || die
	fi

	if use lldb; then
		# Do not install dummy readline.so module from
		# https://llvm.org/bugs/show_bug.cgi?id=18841
		sed -e 's/add_subdirectory(readline)/#&/' \
			-i tools/lldb/scripts/Python/modules/CMakeLists.txt || die
		# Do not install bundled six module
		eapply "${FILESDIR}"/3.9.0/lldb/six.patch
	fi

	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

multilib_src_configure() {
	local targets
	if use multitarget; then
		targets=all
	else
		targets='host;BPF;CppBackend'
		use video_cards_radeon && targets+=';AMDGPU'
	fi

	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$(pkg-config --cflags-only-I libffi)
		ffi_ldflags=$(pkg-config --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_ENABLE_TIMESTAMPS=OFF
		-DLLVM_TARGETS_TO_BUILD="${targets}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DWITH_POLLY=OFF # TODO

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"

		-DHAVE_HISTEDIT_H=$(usex libedit)
	)

	if use clang; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
			# libgomp support fails to find headers without explicit -I
			# furthermore, it provides only syntax checking
			-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

			# override default stdlib and rtlib
			-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
			-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

			# compiler-rt's test cases depend on sanitizer
			-DCOMPILER_RT_BUILD_SANITIZERS=$(usex sanitize)
			-DCOMPILER_RT_INCLUDE_TESTS=$(usex sanitize)
		)
	fi

	if use lldb; then
		mycmakeargs+=(
			-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
			-DLLDB_DISABLE_CURSES=$(usex !ncurses)
			-DLLDB_ENABLE_TERMINFO=$(usex ncurses)
		)
	fi

	if ! multilib_is_native_abi || ! use ocaml; then
		mycmakeargs+=(
			-DOCAMLFIND=NO
		)
	fi
#	Note: go bindings have no CMake rules at the moment
#	but let's kill the check in case they are introduced
#	if ! multilib_is_native_abi || ! use go; then
		mycmakeargs+=(
			-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND
		)
#	fi

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DLLVM_INSTALL_UTILS=ON
		)

		if use clang; then
			mycmakeargs+=(
				-DCLANG_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/clang"
			)
		fi

		if use gold; then
			mycmakeargs+=(
				-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
			)
		fi

		if use lldb; then
			mycmakeargs+=(
				-DLLDB_DISABLE_PYTHON=$(usex !python)
			)
		fi

	else
		if use clang; then
			mycmakeargs+=(
				# disable compiler-rt on non-native ABI because:
				# 1. it fails to configure because of -m32
				# 2. it is shared between ABIs so no point building
				# it multiple times
				-DLLVM_EXTERNAL_COMPILER_RT_BUILD=OFF
				-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_BUILD=OFF
			)
		fi
		if use lldb; then
			mycmakeargs+=(
				# only run swig on native abi
				-DLLDB_DISABLE_PYTHON=ON
			)
		fi
	fi

	if use clang; then
		mycmakeargs+=(
			-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
			-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
			-DCLANG_LIBDIR_SUFFIX="${NATIVE_LIBDIR#lib}"
		)

		# -- not needed when compiler-rt is built with host compiler --
		# cmake passes host C*FLAGS to compiler-rt build
		# which is performed using clang, so we need to filter out
		# some flags clang does not support
		# (if you know some more flags that don't work, let us know)
		#filter-flags -msahf -frecord-gcc-switches
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/llvm-tblgen" ]] \
			|| die "/usr/bin/llvm-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN=/usr/bin/llvm-tblgen
		)

		if use clang; then
			[[ -x "/usr/bin/clang-tblgen" ]] \
				|| die "/usr/bin/clang-tblgen not found or usable"
			mycmakeargs+=(
				-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
			)
		fi
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	# TODO: not sure why this target is not correctly called
	multilib_is_native_abi && use doc && use ocaml && cmake-utils_src_make docs/ocaml_doc

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local test_targets=( check )
	# clang tests won't work on non-native ABI because we skip compiler-rt
	multilib_is_native_abi && use clang && test_targets+=( check-clang )
	cmake-utils_src_make "${test_targets[@]}"
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/config.h
		/usr/include/llvm/Config/llvm-config.h
	)

	if use clang; then
		# note: magic applied in multilib_src_install()!
		CLANG_VERSION=${PV%.*}

		MULTILIB_CHOST_TOOLS+=(
			/usr/bin/clang
			/usr/bin/clang++
			/usr/bin/clang-cl
			/usr/bin/clang-${CLANG_VERSION}
			/usr/bin/clang++-${CLANG_VERSION}
			/usr/bin/clang-cl-${CLANG_VERSION}
		)

		MULTILIB_WRAPPED_HEADERS+=(
			/usr/include/clang/Config/config.h
		)
	fi

	multilib-minimal_src_install

	# Remove unnecessary headers on FreeBSD, bug #417171
	if use kernel_FreeBSD && use clang; then
		rm "${ED}"usr/lib/clang/${PV}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi; then
		# Install man pages.
		use doc || doman "${WORKDIR}"/${PN}-3.8.0-manpages/*.1

		# Symlink the gold plugin.
		if use gold; then
			dodir "/usr/${CHOST}/binutils-bin/lib/bfd-plugins"
			dosym "../../../../$(get_libdir)/LLVMgold.so" \
				"/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so"
		fi
	fi

	# apply CHOST and CLANG_VERSION to clang executables
	# they're statically linked so we don't have to worry about the lib
	if use clang; then
		local clang_tools=( clang clang++ clang-cl )
		local i

		# cmake gives us:
		# - clang-X.Y
		# - clang -> clang-X.Y
		# - clang++, clang-cl -> clang
		# we want to have:
		# - clang-X.Y
		# - clang++-X.Y, clang-cl-X.Y -> clang-X.Y
		# - clang, clang++, clang-cl -> clang*-X.Y
		# so we need to fix the two tools
		for i in "${clang_tools[@]:1}"; do
			rm "${ED%/}/usr/bin/${i}" || die
			dosym "clang-${CLANG_VERSION}" "/usr/bin/${i}-${CLANG_VERSION}"
			dosym "${i}-${CLANG_VERSION}" "/usr/bin/${i}"
		done

		# now prepend ${CHOST} and let the multilib-build.eclass symlink it
		if ! multilib_is_native_abi; then
			# non-native? let's replace it with a simple wrapper
			for i in "${clang_tools[@]}"; do
				rm "${ED%/}/usr/bin/${i}-${CLANG_VERSION}" || die
				cat > "${T}"/wrapper.tmp <<-_EOF_
					#!${EPREFIX}/bin/sh
					exec "${i}-${CLANG_VERSION}" $(get_abi_CFLAGS) "\${@}"
				_EOF_
				newbin "${T}"/wrapper.tmp "${i}-${CLANG_VERSION}"
			done
		fi
	fi
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/.
	# some users may find it useful
	dodoc utils/vim/vimrc

	if use clang; then
		pushd tools/clang >/dev/null || die

		if use python ; then
			pushd bindings/python/clang >/dev/null || die

			python_moduleinto clang
			python_domodule *.py

			popd >/dev/null || die
		fi

		# AddressSanitizer symbolizer (currently separate)
		dobin "${S}"/projects/compiler-rt/lib/asan/scripts/asan_symbolize.py

		popd >/dev/null || die

		python_fix_shebang "${ED}"
		if use static-analyzer; then
			python_optimize "${ED}"usr/share/scan-view
		fi
	fi
}

pkg_postinst() {
	if use clang && ! has_version 'sys-libs/libomp'; then
		elog "To enable OpenMP support in clang, install sys-libs/libomp."
	fi
}
