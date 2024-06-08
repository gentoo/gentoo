# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library to support lingoteach-ui and for generic lesson development"
HOMEPAGE="http://lingoteach.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/lingoteach/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug zlib"

RDEPEND="
	zlib? ( sys-libs/zlib )
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable zlib compression)
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	mv "${ED}/usr/share/doc/${P}" "${ED}/usr/share/doc/${PF}" || die
}
