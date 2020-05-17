# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs flag-o-matic

DESCRIPTION="american fuzzy lop - compile-time instrumentation fuzzer"
HOMEPAGE="https://lcamtuf.coredump.cx/afl/"
SRC_URI="https://lcamtuf.coredump.cx/afl/releases/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="sys-devel/gcc:*
	sys-devel/clang:="
RDEPEND="${DEPEND}"
QA_PREBUILT="/usr/share/afl/testcases/others/elf/small_exec.elf"

src_compile() {
	emake CC="$(tc-getCC)" \
		PREFIX="/usr" \
		HELPER_PATH="/usr/$(get_libdir)/afl" \
		DOC_PATH="/usr/share/doc/${PF}"
	CC="clang" CXX="clang++" strip-unsupported-flags
	cd llvm_mode || die
	emake \
		PREFIX="/usr" \
		HELPER_PATH="/usr/$(get_libdir)/afl" \
		DOC_PATH="/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" \
		PREFIX="/usr" \
		HELPER_PATH="/usr/$(get_libdir)/afl" \
		DOC_PATH="/usr/share/doc/${PF}" \
		install
}
