# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Transforming bitmaps into vector graphics"
HOMEPAGE="http://potrace.sourceforge.net/"
SRC_URI="http://potrace.sourceforge.net/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="metric static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	tc-export CC # bug 610098
	local myeconfargs=(
		--enable-shared
		--enable-zlib
		--with-libpotrace
		$(use_enable metric a4)
		$(use_enable metric)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}
