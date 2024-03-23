# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 17 )
LLVM_OPTIONAL=1

inherit check-reqs cmake edo llvm-r1 toolchain-funcs

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ziglang/zig.git"
	inherit git-r3
else
	SRC_URI="https://ziglang.org/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64"
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
SLOT="$(ver_cut 1-2)"
IUSE="doc +llvm"
REQUIRED_USE="
	!llvm? ( !doc )
	llvm? ( ${LLVM_REQUIRED_USE} )
"

BUILD_DIR="${S}/build"

# Zig requires zstd and zlib compression support in LLVM, if using LLVM backend.
# (non-LLVM backends don't require these)
# They are not required "on their own", so please don't add them here.
# You can check https://github.com/ziglang/zig-bootstrap in future, to see
# options that are passed to LLVM CMake building (excluding "static" ofc).
DEPEND="
	llvm? (
		$(llvm_gen_dep '
			sys-devel/clang:${LLVM_SLOT}
			sys-devel/lld:${LLVM_SLOT}
			sys-devel/llvm:${LLVM_SLOT}[zstd]
		')
	)
"

RDEPEND="
	${DEPEND}
"

IDEPEND="app-eselect/eselect-zig"

# see https://github.com/ziglang/zig/issues/3382
# For now, Zig Build System doesn't support enviromental CFLAGS/LDFLAGS/etc.
QA_FLAGS_IGNORED="usr/.*/zig/${PV}/bin/zig"

RESTRICT="!llvm? ( test )"

# Since commit https://github.com/ziglang/zig/commit/e7d28344fa3ee81d6ad7ca5ce1f83d50d8502118
# Zig uses self-hosted compiler only
CHECKREQS_MEMORY="4G"

ctarget_to_zigtarget() {
	# Zig's Target Format: arch-os-abi
	local CTARGET="${CTARGET:-${CHOST}}"

	local ZIG_ARCH
	case "${CTARGET%%-*}" in
		i?86)		ZIG_ARCH=x86;;
		sparcv9)	ZIG_ARCH=sparc64;;
		*)		ZIG_ARCH="${CTARGET%%-*}";; # Same as in CHOST
	esac

	local ZIG_OS
	case "${CTARGET}" in
		*linux*)	ZIG_OS=linux;;
		*apple*)	ZIG_OS=macos;;
	esac

	local ZIG_ABI
	case "${CTARGET##*-}" in
		gnu)		ZIG_ABI=gnu;;
		solaris*)	ZIG_OS=solaris ZIG_ABI=none;;
		darwin*)	ZIG_ABI=none;;
		*)		ZIG_ABI="${CTARGET##*-}";; # Same as in CHOST
	esac

	echo "${ZIG_ARCH}-${ZIG_OS}-${ZIG_ABI}"
}

get_zig_mcpu() {
	local ZIG_DEFAULT_MCPU=native
	tc-is-cross-compiler && ZIG_DEFAULT_MCPU=baseline
	echo "${ZIG_MCPU:-${ZIG_DEFAULT_MCPU}}"
}

get_zig_target() {
	local ZIG_DEFAULT_TARGET=native
	tc-is-cross-compiler && ZIG_DEFAULT_TARGET="$(ctarget_to_zigtarget)"
	echo "${ZIG_TARGET:-${ZIG_DEFAULT_TARGET}}"
}

pkg_setup() {
	# Useful for debugging and a little bit more deterministic.
	export ZIG_LOCAL_CACHE_DIR="${T}/zig-local-cache"
	export ZIG_GLOBAL_CACHE_DIR="${T}/zig-global-cache"

	export ZIG_SYS_INSTALL_DEST="${EPREFIX}/usr/$(get_libdir)/zig/${PV}"

	use llvm && llvm-r1_pkg_setup
	check-reqs_pkg_setup
}

src_configure() {
	if ! use llvm; then
		mkdir -p "${BUILD_DIR}/stage3" || die
		# Currently, Zig without LLVM extensions lacks most optimizations.
		export ZIG_BOOTSTRAP_STAGE3_FLAGS=(
			-Dtarget="$(get_zig_target)"
			-Dcpu="$(get_zig_mcpu)"
			-Doptimize=Debug
			-Dno-autodocs
			-Dno-langref
			-Denable-llvm=false
			-Dforce-link-libc
		)
		return
	fi

	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
		-DZIG_SHARED_LLVM=ON
		-DZIG_TARGET_TRIPLE="$(get_zig_target)"
		-DZIG_TARGET_MCPU="$(get_zig_mcpu)"
		-DZIG_USE_LLVM_CONFIG=ON
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix)"
		-DCMAKE_INSTALL_PREFIX="${ZIG_SYS_INSTALL_DEST}"
	)

	cmake_src_configure
}

src_compile() {
	# Remove "limit memory usage" flags, it's already verified by
	# CHECKREQS_MEMORY and causes unneccessary errors. Upstream set them
	# according to CI OOM failures, which are higher than during Gentoo build.
	sed -i -e '/\.max_rss = .*,/d' build.zig || die

	if ! use llvm; then
		$(tc-getCC) -o bootstrap bootstrap.c || die "Zig's bootstrap.c compilation failed"
		edob ./bootstrap
		edo ./zig2 build install --prefix "${BUILD_DIR}/stage3/" "${ZIG_BOOTSTRAP_STAGE3_FLAGS[@]}"
		return
	fi

	cmake_src_compile

	"${BUILD_DIR}/stage3/bin/zig" env || die "Zig compilation failed"

	if use doc; then
		cd "${BUILD_DIR}" || die
		edo ./stage3/bin/zig build std-docs --prefix "${S}/docgen/"
		edo ./stage3/bin/zig build langref --prefix "${S}/docgen/"
	fi
}

src_test() {
	cd "${BUILD_DIR}" || die
	local ZIG_TEST_ARGS="-Dstatic-llvm=false -Denable-llvm -Dskip-non-native \
		-Doptimize=ReleaseSafe -Dtarget=$(get_zig_target) -Dcpu=$(get_zig_mcpu)"
	local ZIG_TEST_STEPS=(
		test-fmt test-cases test-behavior test-c-import test-compiler-rt test-universal-libc test-compare-output
		test-standalone test-c-abi test-link test-stack-traces test-cli test-asm-link test-translate-c
		test-run-translated-c test-std
	)

	local step
	for step in "${ZIG_TEST_STEPS[@]}" ; do
		edob ./stage3/bin/zig build ${step} ${ZIG_TEST_ARGS}
	done
}

src_install() {
	local DOCS=( "README.md" "doc/build.zig.zon.md" )
	use doc && local HTML_DOCS=( "docgen/doc/langref.html" "docgen/doc/std" )

	if ! use llvm; then
		DESTDIR="${D}" edo ./zig2 build install --prefix "${ZIG_SYS_INSTALL_DEST}" "${ZIG_BOOTSTRAP_STAGE3_FLAGS[@]}"
		einstalldocs
	else
		cmake_src_install
	fi

	cd "${ED}/usr/$(get_libdir)/zig/${PV}/" || die
	mv lib/zig/ lib2/ || die
	rm -rf lib/ || die
	mv lib2/ lib/ || die
	dosym -r "/usr/$(get_libdir)/zig/${PV}/bin/zig" "/usr/bin/zig-${PV}"
}

pkg_postinst() {
	eselect zig update ifunset

	if ! use llvm; then
		elog "Currently, Zig built without LLVM support lacks some"
		elog "important features such as most optimizations, @cImport, etc."
		elog "They are listed under \"Building from Source without LLVM\""
		elog "section of the README file from \"/usr/share/doc/${PF}\" ."
		elog "It's recommended to use C backend directly with this stage2 build."
	fi
}

pkg_postrm() {
	eselect zig update ifunset
}
