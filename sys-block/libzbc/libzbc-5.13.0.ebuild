# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A library and tools for working with ZBC and ZAC disks"
HOMEPAGE="https://github.com/hgst/libzbc"
SRC_URI="https://github.com/hgst/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="gtk"

DEPEND="
	gtk? ( x11-libs/gtk+:3 )
	>=sys-kernel/linux-headers-4.13
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk gui) \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
