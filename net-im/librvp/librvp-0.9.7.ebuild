# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An RVP (Microsoft Exchange Instant Messaging) plugin for Pidgin"
HOMEPAGE="https://www.waider.ie/hacks/workshop/c/rvp/"
SRC_URI="https://www.waider.ie/hacks/workshop/c/rvp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="net-im/pidgin[gtk]"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	econf \
		--with-gaim-plugin-dir="${EPREFIX}"/usr/$(get_libdir)/pidgin \
		--with-gaim-data-dir="${EPREFIX}"/usr/share/pixmaps/pidgin \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
