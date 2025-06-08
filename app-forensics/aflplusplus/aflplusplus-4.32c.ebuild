# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {15..20} )
PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic toolchain-funcs llvm-r1 optfeature python-single-r1

AFL_PATCHSET="${PN}-4.32c-patches"
DESCRIPTION="Fork of AFL, the popular compile-time instrumentation fuzzer"
HOMEPAGE="https://github.com/AFLplusplus/AFLplusplus"
SRC_URI="https://github.com/AFLplusplus/AFLplusplus/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${AFL_PATCHSET}.tar.xz"
S="${WORKDIR}"/AFLplusplus-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests involve heavy use of LD_PRELOAD in some cases
# This isn't compatible with sandbox
RESTRICT="test"

RDEPEND="
	${PYTHON_DEPS}
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	!app-forensics/afl
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"

QA_FLAGS_IGNORED="
	usr/lib.*/afl/afl-gcc-cmplog-pass.so
	usr/lib.*/afl/afl-gcc-cmptrs-pass.so
"
QA_PREBUILT="usr/share/afl/testcases/others/elf/small_exec.elf"

PATCHES=(
	"${WORKDIR}"/${AFL_PATCHSET}
	"${FILESDIR}"/${PN}-4.32c-gcc16.patch
)

pkg_setup() {
	llvm-r1_pkg_setup
	python-single-r1_pkg_setup
}

mymake() {
	# afl-fuzz spews garbage to stdout if the environment contains any
	# variables whose name beginning with USE_ (including the underscore),
	# regardless of their value (even if empty!).  The ebuild environment
	# contains several such variables and the garbage that gets printed
	# ends up in the generated man page.
	#
	# We can work around the problem by unsetting all these variables when
	# running make.
	local badvars=("${!USE_@}")

	env "${badvars[@]/#/-u}" emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS_FLTO="" \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}" \
		MAN_PATH="${EPREFIX}/usr/share/man/man8" \
		"$@"
}

src_compile() {
	# bug #945258
	append-cflags -std=gnu17

	mymake
}

src_test() {
	mymake test
}

src_install() {
	mymake DESTDIR="${D}" install
	dostrip -x /usr/share/afl/testcases/
}

pkg_postinst() {
	# TODO: Any others?
	optfeature "fuzzing with AFL_USE_ASAN" llvm-runtimes/compiler-rt-sanitizers[asan]
	optfeature "fuzzing with AFL_USE_MSAN" llvm-runtimes/compiler-rt-sanitizers[msan]
}
