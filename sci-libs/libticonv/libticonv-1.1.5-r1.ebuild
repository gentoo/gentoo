# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Charset conversion library for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="https://downloads.sourceforge.net/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc iconv static-libs"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS LOGO NEWS README ChangeLog docs/api.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable iconv)
}

src_install() {
	if use doc; then
		HTML_DOCS=( docs/html/. )
		DOCS+=( docs/charsets )
	fi
	default
	find "${D}" -name '*.la' -delete || die
}
