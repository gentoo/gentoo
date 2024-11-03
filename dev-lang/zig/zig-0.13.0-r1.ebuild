# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=18
inherit edo check-reqs cmake llvm multiprocessing toolchain-funcs

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org https://github.com/ziglang/zig"

BDEPEND="test? ( !!<sys-apps/sandbox-2.39 )"
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

	BDEPEND+=" verify-sig? ( sec-keys/minisig-keys-zig-software-foundation )"
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
IUSE="doc test"
RESTRICT="!test? ( test )"

BUILD_DIR="${S}/build"

# Zig requires zstd and zlib compression support in LLVM, if using LLVM backend.
# (non-LLVM backends don't require these)
# They are not required "on their own", so please don't add them here.
# You can check https://github.com/ziglang/zig-bootstrap in future, to see
# options that are passed to LLVM CMake building (excluding "static" ofc).
DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/lld:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=[zstd]
"

RDEPEND="
	${DEPEND}
"

IDEPEND="app-eselect/eselect-zig"

# see https://github.com/ziglang/zig/issues/3382
# For now, Zig Build System doesn't support enviromental CFLAGS/LDFLAGS/etc.
QA_FLAGS_IGNORED="usr/.*/zig/${PV}/bin/zig"

# Since commit https://github.com/ziglang/zig/commit/e7d28344fa3ee81d6ad7ca5ce1f83d50d8502118
# Zig uses self-hosted compiler only
CHECKREQS_MEMORY="4G"

PATCHES=(
	"${FILESDIR}/${P}-test-fmt-no-doc.patch"
	"${FILESDIR}/${P}-test-std-kernel-version.patch"
	"${DISTDIR}/${P}-llvm-18.1.8-r6-fix.patch"
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

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
	llvm_pkg_setup
	check-reqs_pkg_setup
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.minisig}
	fi
	default
}

src_configure() {
	# Useful for debugging and a little bit more deterministic.
	export ZIG_LOCAL_CACHE_DIR="${T}/zig-local-cache"
	export ZIG_GLOBAL_CACHE_DIR="${T}/zig-global-cache"

	local mycmakeargs=(
		-DZIG_SHARED_LLVM=ON
		-DZIG_TARGET_TRIPLE="$(get_zig_target)"
		-DZIG_TARGET_MCPU="$(get_zig_mcpu)"
		-DZIG_USE_LLVM_CONFIG=ON
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/zig/${PV}"
	)

	cmake_src_configure
}

src_compile() {
	# Remove "limit memory usage" flags, it's already verified by
	# CHECKREQS_MEMORY and causes unneccessary errors. Upstream set them
	# according to CI OOM failures, which are higher than during Gentoo build.
	sed -i -e '/\.max_rss = .*,/d' build.zig || die

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
	local ZIG_TEST_ARGS=(
		-j$(makeopts_jobs)
		--color on
		--summary all
		--verbose
		-Dstatic-llvm=false
		-Denable-llvm
		-Dskip-non-native
		-Doptimize=Debug
		-Dtarget="$(get_zig_target)"
		-Dcpu="$(get_zig_mcpu)"
	)
	local ZIG_TEST_STEPS=(
		test-asm-link
		test-behavior
		test-c-abi
		test-c-import
		test-cases
		test-cli
		test-compare-output
		test-compiler-rt
		test-fmt
		test-link
		test-run-translated-c
		test-stack-traces
		test-standalone
		test-std
		test-translate-c
		test-universal-libc
	)

	local step
	for step in "${ZIG_TEST_STEPS[@]}" ; do
		# to keep the verbosity, don't use edob here
		./stage3/bin/zig build ${step} ${ZIG_TEST_ARGS[@]} || die
	done
}

src_install() {
	use doc && local HTML_DOCS=( "docgen/doc/langref.html" "docgen/doc/std" )
	cmake_src_install

	cd "${ED}/usr/$(get_libdir)/zig/${PV}/" || die
	mv lib/zig/ lib2/ || die
	rm -rf lib/ || die
	mv lib2/ lib/ || die
	dosym -r "/usr/$(get_libdir)/zig/${PV}/bin/zig" "/usr/bin/zig-${PV}"
}

pkg_postinst() {
	eselect zig update ifunset || die
}

pkg_postrm() {
	eselect zig update ifunset || die
}
