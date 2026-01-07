# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Parallel bzip2 utility"
HOMEPAGE="https://github.com/kjn/lbzip2/"
SRC_URI="mirror://gentoo/05/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug static"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-s_isreg.patch
	"${FILESDIR}"/${P}-fix-unaligned.patch
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-clang16-musl-info.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static

	# fix clang miscompilation: #910438
	# see also: https://github.com/llvm/llvm-project/issues/87189
	tc-is-clang && test-flag-CC -mno-avx512f && append-cflags -mno-avx512f

	local myeconfargs=(
		$(use_enable debug tracing)
	)
	econf "${myeconfargs[@]}"
}
