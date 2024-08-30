# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Parallel bzip2 utility"
HOMEPAGE="https://github.com/kjn/lbzip2/"
SRC_URI="mirror://gentoo/05/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
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

	local myeconfargs=(
		$(use_enable debug tracing)
	)
	econf "${myeconfargs[@]}"
}
