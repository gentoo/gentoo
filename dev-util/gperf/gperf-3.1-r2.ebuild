# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A perfect hash function generator"
HOMEPAGE="https://www.gnu.org/software/gperf/"
SRC_URI="mirror://gnu/gperf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${P}-strncmp-decl-mismatch.patch
	"${FILESDIR}"/${P}-clang-16-wregister.patch
	"${FILESDIR}"/${P}-parallel-tests.patch
)

src_prepare() {
	sed -i \
		-e "/^CPPFLAGS /s:=:+=:" \
		*/Makefile.in || die #444078

	default
}

src_configure() {
	# Aliasing violation (bug #858377)
	append-flags -fno-strict-aliasing
	filter-lto

	econf --cache-file="${S}"/config.cache
}
