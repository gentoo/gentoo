# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
LLVM_MAX_SLOT=14
inherit toolchain-funcs llvm optfeature python-single-r1

DESCRIPTION="A fork of AFL, the popular compile-time instrumentation fuzzer"
HOMEPAGE="https://github.com/AFLplusplus/AFLplusplus"
SRC_URI="https://github.com/AFLplusplus/AFLplusplus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AFLplusplus-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests involve heavy use of LD_PRELOAD in some cases
# This isn't compatible with sandbox
RESTRICT="test"

# It turns out we need Clang too
RDEPEND="${PYTHON_DEPS}
	>=sys-devel/llvm-12:=
	|| (
		sys-devel/clang:12
		sys-devel/clang:13
		sys-devel/clang:${LLVM_MAX_SLOT}
	)
	!app-forensics/afl"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"

QA_PREBUILT="usr/share/afl/testcases/others/elf/small_exec.elf"

PATCHES=(
	"${FILESDIR}"/${PN}-4.01c-respect-flags.patch
	"${FILESDIR}"/${PN}-4.01c-no-ignore-errors-makefile.patch
	"${FILESDIR}"/${PN}-4.01c-lld-detect.patch
)

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}" && \
		has_version -b "sys-devel/llvm:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS_FLTO="" \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}" \
		MAN_PATH="${EPREFIX}/usr/share/man/man8"
}

src_test() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)"
}

src_install() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}" \
		MAN_PATH="${EPREFIX}/usr/share/man/man8" \
		install
	dostrip -x /usr/share/afl/testcases/
}

pkg_postinst() {
	# TODO: Any others?
	optfeature "fuzzing with AFL_USE_ASAN" sys-libs/compiler-rt-sanitizers[asan]
	optfeature "fuzzing with AFL_USE_MSAN" sys-libs/compiler-rt-sanitizers[msan]
}
