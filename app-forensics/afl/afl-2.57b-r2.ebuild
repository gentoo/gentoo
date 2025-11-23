# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

# See https://github.com/google/AFL/pull/117
PATCHES=(
	"${FILESDIR}/${P}-install-readmemd.diff"
	"${FILESDIR}/${P}-implicit-int-clang16.patch"
)

DESCRIPTION="american fuzzy lop - compile-time instrumentation fuzzer"
HOMEPAGE="https://lcamtuf.coredump.cx/afl/"
SRC_URI="https://github.com/google/AFL/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-devel/gcc:*
	!app-forensics/aflplusplus"
RDEPEND="${DEPEND}"
QA_PREBUILT="/usr/share/afl/testcases/others/elf/small_exec.elf"

S="${WORKDIR}/AFL-${PV}"

src_compile() {
	emake CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}"
#	Not compatible with latest clang, see
#	https://github.com/google/AFL/issues/151
#
#	CC="clang" CXX="clang++" strip-unsupported-flags
#	cd llvm_mode || die
#	emake \
#		PREFIX="${EPREFIX}/usr" \
#		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
#		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		HELPER_PATH="${EPREFIX}/usr/$(get_libdir)/afl" \
		DOC_PATH="${EPREFIX}/usr/share/doc/${PF}" \
		install
}
