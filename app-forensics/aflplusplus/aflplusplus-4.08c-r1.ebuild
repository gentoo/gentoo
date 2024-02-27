# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
LLVM_MAX_SLOT=17
LLVM_MIN_SLOT=14
inherit toolchain-funcs llvm optfeature python-single-r1

AFL_PATCHSET="${PN}-4.07c-patches"
DESCRIPTION="Fork of AFL, the popular compile-time instrumentation fuzzer"
HOMEPAGE="https://github.com/AFLplusplus/AFLplusplus"
SRC_URI="https://github.com/AFLplusplus/AFLplusplus/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${AFL_PATCHSET}.tar.xz"
S="${WORKDIR}"/AFLplusplus-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Tests involve heavy use of LD_PRELOAD in some cases
# This isn't compatible with sandbox
RESTRICT="test"

LLVM_DEPS="
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=
	|| (
"
# We go downwards as Portage prefers left-most in || ( .. )
for ((i=${LLVM_MAX_SLOT}; i >= ${LLVM_MIN_SLOT}; i--)) ; do
	LLVM_DEPS+=" sys-devel/clang:${i}"
done
LLVM_DEPS+=" )"
unset i

RDEPEND="
	${PYTHON_DEPS}
	${LLVM_DEPS}
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
)

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}" && \
		has_version -b "sys-devel/llvm:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

mymake() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS_FLTO="" \
		LLVM_CONFIG="$(get_llvm_prefix ${LLVM_MAX_SLOT})"/bin/llvm-config \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}" \
		MAN_PATH="${EPREFIX}/usr/share/man/man8" \
		"$@"
}

src_compile() {
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
	optfeature "fuzzing with AFL_USE_ASAN" sys-libs/compiler-rt-sanitizers[asan]
	optfeature "fuzzing with AFL_USE_MSAN" sys-libs/compiler-rt-sanitizers[msan]
}
