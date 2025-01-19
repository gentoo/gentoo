# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
LLVM_OPTIONAL=1

ZIG_SLOT="$(ver_cut 1-2)"
ZIG_OPTIONAL=1

inherit check-reqs cmake flag-o-matic edo llvm-r2 toolchain-funcs zig

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/ https://github.com/ziglang/zig/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ziglang/zig.git"
	inherit git-r3
else
	VERIFY_SIG_METHOD=minisig
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/minisig-keys/zig-software-foundation.pub
	inherit verify-sig

	SRC_URI="
		https://ziglang.org/download/${PV}/${P}.tar.xz
		verify-sig? ( https://ziglang.org/download/${PV}/${P}.tar.xz.minisig )
		https://codeberg.org/BratishkaErik/distfiles/releases/download/dev-lang%2Fzig-${PV}/${P}-llvm-18.1.8-r6-fix.patch
	"
	KEYWORDS="~amd64 ~arm ~arm64"

	BDEPEND="verify-sig? ( sec-keys/minisig-keys-zig-software-foundation )"
fi

# project itself: MIT
# There are bunch of projects under "lib/" folder that are needed for cross-compilation.
# Files that are unnecessary for cross-compilation are removed by upstream
# and therefore their licenses (if any special) are not included.
# lib/libunwind: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libcxxabi: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libcxx: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libc/wasi: || ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 ) public-domain
# lib/libc/musl: MIT BSD-2
# lib/libc/mingw: ZPL public-domain BSD-2 ISC HPND
# lib/libc/glibc: BSD HPND ISC inner-net LGPL-2.1+
LICENSE="MIT Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT ) || ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 ) public-domain BSD-2 ZPL ISC HPND BSD inner-net LGPL-2.1+"
SLOT="${ZIG_SLOT}"
IUSE="debug doc +llvm"
REQUIRED_USE="
	!llvm? ( !doc )
	llvm? ( ${LLVM_REQUIRED_USE} )
"

# Used by both "cmake" and "zig" eclasses.
BUILD_DIR="${WORKDIR}/${P}_build"

# Zig requires zstd and zlib compression support in LLVM, if using LLVM backend.
# (non-LLVM backends don't require these)
# They are not required "on their own", so please don't add them here.
# You can check https://github.com/ziglang/zig-bootstrap in future, to see
# options that are passed to LLVM CMake building (excluding "static" ofc).
LLVM_DEPEND="$(llvm_gen_dep '
	llvm-core/clang:${LLVM_SLOT}
	llvm-core/lld:${LLVM_SLOT}[zstd]
	llvm-core/llvm:${LLVM_SLOT}[zstd]
')"

BDEPEND+=" llvm? ( ${LLVM_DEPEND} )"
DEPEND="llvm? ( ${LLVM_DEPEND} )"
RDEPEND="${DEPEND}"
IDEPEND="app-eselect/eselect-zig"

DOCS=( "README.md" "doc/build.zig.zon.md" )

PATCHES=(
	"${FILESDIR}/zig-0.13.0-test-std-kernel-version.patch"
	"${FILESDIR}/zig-0.13.0-skip-test-stack_iterator.patch"
	"${DISTDIR}/${P}-llvm-18.1.8-r6-fix.patch"
)

# zig.eclass does not set this for us since we use ZIG_OPTIONAL=1
QA_FLAGS_IGNORED="usr/.*/zig/${PV}/bin/zig"

# Since commit https://github.com/ziglang/zig/commit/e7d28344fa3ee81d6ad7ca5ce1f83d50d8502118
# Zig uses self-hosted compiler only
CHECKREQS_MEMORY="4G"

pkg_setup() {
	# Skip detecting zig executable.
	declare -r -g ZIG_VER="${PV}"
	ZIG_EXE="not-applicable" zig_pkg_setup

	declare -r -g ZIG_SYS_INSTALL_DEST="${EPREFIX}/usr/$(get_libdir)/zig/${PV}"

	if use llvm; then
		[[ ${MERGE_TYPE} != binary ]] && llvm_cbuild_setup
	fi

	# Requires running stage3 which is built for cross-target.
	if use doc && tc-is-cross-compiler; then
		die "USE=doc is not yet supported when cross-compiling"
	fi

	check-reqs_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		if use verify-sig; then
			verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.minisig}
		fi
	fi
	zig_src_unpack
}

src_prepare() {
	if use llvm; then
		cmake_src_prepare
	else
		# Sync with zig_src_prepare
		default_src_prepare
		mkdir -p "${BUILD_DIR}" || die
		einfo "BUILD_DIR: \"${BUILD_DIR}\""
		# "--system" mode is not used during bootstrap.
	fi

	# Remove "limit memory usage" flags, it's already verified by
	# CHECKREQS_MEMORY and causes unneccessary errors. Upstream set them
	# according to CI OOM failures, which are not applicable to normal Gentoo build.
	sed -i -e '/\.max_rss = .*,/d' build.zig || die
}

src_configure() {
	# Has no effect on final binary and only causes failures during bootstrapping.
	filter-lto

	# Used during bootstrapping. stage1/stage2 have limited functionality
	# and can't resolve native target, so we pass target in exact form.
	declare -r -g ZIG_HOST_AS_TARGET="$(zig-utils_c_env_to_zig_target "${CBUILD:-${CHOST}}" "${CFLAGS}"})"

	# Note that if we are building with CMake, "my_zbs_args"
	# are used only after compiling zig2.
	local my_zbs_args=(
		--zig-lib-dir "${S}/lib/"

		--prefix "${ZIG_SYS_INSTALL_DEST}/"
		--prefix-lib-dir lib/

		# These are built separately
		-Dno-langref=true
		-Dstd-docs=false

		# More commands and options if "debug" is enabled.
		-Ddebug-extensions=$(usex debug true false)
		# More asserts and so on by default if "debug" is enabled.
		--release=$(usex debug safe fast)
	)

	# Scenarios of compilation:

	# With LLVM, native:
	# CMake:
	#   * generate "config.h" for LLVM libraries and build "zigcpp"
	#   * build "zig2" using common "config.h" and "zigcpp"
	# build.zig:
	#   * build "stage3" using common "config.h" and "zigcpp"

	# With LLVM, cross-compiled:
	# CMake:
	#   * generate cross-target "config.h" for LLVM libraries from ESYSROOT
	#     and build cross-target "zigcpp", and stash them away
	#   * generate native "config.h" for LLVM libraries from BROOT and
	#     build native "zigcpp"
	#   * build native "zig2" using native "config.h" and "zigcpp"
	# build.zig:
	#   * build cross-target "stage3" using stashed "config.h" and "zigcpp"

	# Without LLVM:
	# bootstrap.c:
	#   * build native "zig2"
	# build.zig:
	#   * build (cross-)target "stage3"

	if use llvm; then
		my_zbs_args+=(
			-Denable-llvm=true
			-Dstatic-llvm=false
			-Dconfig_h="${BUILD_DIR}/config.h"
		)
	else
		my_zbs_args+=(
			-Denable-llvm=false
		)
	fi
	zig_src_configure

	if use llvm; then
		local mycmakeargs=(
			-DZIG_SHARED_LLVM=ON
			-DZIG_USE_LLVM_CONFIG=ON
			-DZIG_HOST_TARGET_TRIPLE="${ZIG_HOST_AS_TARGET}"
			# Don't set ZIG_TARGET_TRIPLE, ZIG_TARGET_MCPU and
			# CMAKE_INSTALL_PREFIX because we build up to zig2 max,
			# after that "zig build" is used to compile stage3.

			# Don't set CMAKE_PREFIX_PATH because "llvm_chost_setup"
			# and "llvm_cbuild_setup" already set PATH in such way
			# that suitable llvm-config is found and used in
			# "cmake/Findllvm.cmake", and "cmake.eclass" help with
			# cross-compilation pathes for "Findclang" and "Findlld".

			# CMP0144, Zig has own packages with these names, so ignore
			# LLVM_ROOT, Clang_ROOT, LLD_ROOT from "llvm_chost_setup".
			-DCMAKE_FIND_USE_PACKAGE_ROOT_PATH=OFF
		)
		if tc-is-cross-compiler; then
			# Enable cross-compilation for CMake when filling "config.h"
			# and building "zigcpp". They would be used for stage3 build.
			# Here we are using LLVM from ESYSROOT/DEPEND.
			# Uses script llvm-config.

			# Isolate PATH changes in subshell so that it would not
			# affect next `cmake_src_configure` with BROOT/BDEPEND.
			(
				llvm_chost_setup
				cmake_src_configure
				cmake_build zigcpp
			)

			mv "${BUILD_DIR}/config.h" "${T}/target_config.h" || die
			mv "${BUILD_DIR}/zigcpp/" "${T}/target_zigcpp/" || die
			rm -rf "${BUILD_DIR}" || die
		fi

		# Force disable cross-compilation for CMake when building "zig2".
		# Here we are using LLVM from BROOT/BDEPEND.
		# Uses native llvm-config.

		# Isolate environment changes in subshell so that it would not
		# affect next phases.
		(
			export BUILD_CFLAGS="${CFLAGS}"
			export BUILD_CXXFLAGS="${CXXFLAGS}"
			export BUILD_CPPFLAGS="${CPPFLAGS}"
			export BUILD_LDFLAGS="${LDFLAGS}"
			tc-env_build

			unset SYSROOT
			export CHOST="${CBUILD:-${CHOST}}"
			strip-unsupported-flags
			cmake_src_configure
		)
	fi
}

src_compile() {
	if use llvm; then
		cmake_build zig2

		if tc-is-cross-compiler; then
			rm -rf "${BUILD_DIR}/zigcpp/" || die
			rm -f "${BUILD_DIR}/config.h" || die

			mv "${T}/target_zigcpp/" "${BUILD_DIR}/zigcpp/" || die
			mv "${T}/target_config.h" "${BUILD_DIR}/config.h" || die
		fi
	else
		cd "${BUILD_DIR}" || die
		ln -s "${S}/stage1/" . || die
		ln -s "${S}/src/" . || die
		ln -s "${S}/lib/" . || die

		local native_cc="$(tc-getBUILD_CC)"
		"${native_cc}" -o bootstrap "${S}/bootstrap.c" || die "Zig's bootstrap.c compilation failed"
		ZIG_HOST_TARGET_TRIPLE="${ZIG_HOST_AS_TARGET}" CC="${native_cc}" edo ./bootstrap
	fi

	cd "${BUILD_DIR}" || die
	ZIG_EXE="./zig2" zig_src_compile --prefix stage3/

	# Requires running stage3 which is built for cross-target.
	if ! tc-is-cross-compiler; then
		./stage3/bin/zig env || die "Zig compilation failed"

		if use doc; then
			ZIG_EXE="./stage3/bin/zig" zig_src_compile langref --prefix docgen/
		fi
	fi
}

src_test() {
	if has_version -b app-emulation/qemu; then
		ewarn "QEMU executable was found on your building system."
		ewarn "If you have qemu-binfmt (binfmt_misc) hooks enabled for"
		ewarn "foreign architectures, Zig tests might fail."
		ewarn "In this case, please disable qemu-binfmt and try again."
	fi

	cd "${BUILD_DIR}" || die

	# XXX: When we pass a libc installation to Zig, it will fail to find
	#      the bundled libraries for targets like aarch64-macos and
	#      *-linux-musl. Zig doesn't run binaries for these targets when
	#      -Dskip-non-native is passed, but they are still compiled, so
	#      the test will fail. There's no way to disable --libc once passed,
	#      so we need to strip it from ZBS_ARGS.
	#      See: https://github.com/ziglang/zig/issues/22383
	local args_backup=("${ZBS_ARGS[@]}")

	for ((i = 0; i < ${#ZBS_ARGS[@]}; i++)); do
		if [[ "${ZBS_ARGS[i]}" == "--libc" ]]; then
			unset ZBS_ARGS[i]
			unset ZBS_ARGS[i+1]
			break
		fi
	done

	ZIG_EXE="./stage3/bin/zig" zig_src_test -Dskip-non-native

	ZBS_ARGS=("${args_backup[@]}")
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}/docgen/doc/langref.html" )

	ZIG_EXE="./zig2" zig_src_install

	cd "${D}/${ZIG_SYS_INSTALL_DEST}" || die
	mv lib/zig/ lib2/ || die
	rm -rf lib/ || die
	mv lib2/ lib/ || die
	dosym -r "${ZIG_SYS_INSTALL_DEST}/bin/zig" /usr/bin/zig-${PV}
}

pkg_postinst() {
	eselect zig update ifunset || die

	elog "Starting from 0.12.0, Zig no longer installs"
	elog "precompiled standard library documentation."
	elog "Instead, you can call \`zig std\` to compile it on-the-fly."
	elog "It reflects all edits in standard library automatically."
	elog "See \`zig std --help\` for more information."
	elog "More details here: https://ziglang.org/download/0.12.0/release-notes.html#Redesign-How-Autodoc-Works"

	if ! use llvm; then
		elog "Currently, Zig built without LLVM support lacks some"
		elog "important features such as most optimizations, @cImport, etc."
		elog "They are listed under \"Building from Source without LLVM\""
		elog "section of the README file from \"/usr/share/doc/${PF}\" ."
	fi
}

pkg_postrm() {
	eselect zig update ifunset
}
