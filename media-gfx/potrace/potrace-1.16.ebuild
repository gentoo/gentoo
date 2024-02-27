# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Transforming bitmaps into vector graphics"
HOMEPAGE="https://potrace.sourceforge.net/"
SRC_URI="https://potrace.sourceforge.net/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="metric"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	tc-export CC # bug 610098
	local myeconfargs=(
		--disable-static
		--enable-zlib
		--with-libpotrace
		$(use_enable metric a4)
		$(use_enable metric)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
