# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
inherit edo cmake llvm check-reqs toolchain-funcs

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ziglang/zig.git"
	inherit git-r3
else
	SRC_URI="https://ziglang.org/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
IUSE="doc"

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

# see https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler
# 0.10.0 release - ~9.6 GiB, since we use compiler written in C++ for bootstrapping
# 0.11.0 release - ~2.8 GiB, since we will (at least according to roadmap) use self-hosted compiler
# (transpiled to C via C backend) for bootstrapping
CHECKREQS_MEMORY="10G"

PATCHES=(
	"${FILESDIR}/zig-0.10.0-build-dir-install-stage3.patch"
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
	elog "This version requires 10G of memory for building compiler."
	elog "If you don't have enough memory, you can wait until 0.11.0 release"
	elog "or (if you are risky) use 9999 version (currently requires only 4GB)"
	check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
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
	cmake_src_compile

	if use doc; then
		cd "${BUILD_DIR}" || die
		edo ./zig2 run ../doc/docgen.zig -- ./zig2 ../doc/langref.html.in "${S}/langref.html"
		edo ./zig2 test ../lib/std/std.zig --zig-lib-dir ../lib -fno-emit-bin -femit-docs="${S}/std"
	fi
}

src_test() {
	cd "${BUILD_DIR}" || die
	local ZIG_TEST_ARGS="-Dstatic-llvm=false -Denable-llvm -Dskip-non-native \
		-Drelease -Dtarget=$(get_zig_target) -Dcpu=$(get_zig_mcpu)"
	local ZIG_TEST_STEPS=(
		test-cases test-fmt test-behavior test-compiler-rt test-universal-libc test-compare-output
		test-standalone test-c-abi test-link test-stack-traces test-cli test-asm-link test-translate-c
		test-run-translated-c test-std
	)

	local step
	for step in "${ZIG_TEST_STEPS[@]}" ; do
		edob ./stage3/bin/zig build ${step} ${ZIG_TEST_ARGS}
	done
}

src_install() {
	use doc && local HTML_DOCS=( "langref.html" "std" )
	cmake_src_install
	cd "${ED}/usr/$(get_libdir)/zig/${PV}/" || die
	mv lib/zig/ lib2/ || die
	rm -rf lib/ || die
	mv lib2/ lib/ || die

	dosym -r "/usr/$(get_libdir)/zig/${PV}/bin/zig" "/usr/bin/zig-${PV}"
}

pkg_postinst() {
	eselect zig update ifunset

	elog "0.10.1 release uses self-hosted compiler by default and fixes some bugs from 0.10.0"
	elog "But your code still can be un-compilable since some features still not implemented or bugs not fixed"
	elog "Upstream recommends:"
	elog " * Using old compiler if experiencing such breakage (flag '-fstage1')"
	elog " * Waiting for release 0.11.0 with old compiler removed (these changes are already merged in 9999)"
	elog "Also see: https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler"
	elog "and https://ziglang.org/download/0.10.0/release-notes.html#How-to-Upgrade"
}

pkg_postrm() {
	eselect zig update ifunset
}
