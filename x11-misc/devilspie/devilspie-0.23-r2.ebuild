# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Window matching utility similar to Sawfish's Matched Windows"
HOMEPAGE="https://www.burtonini.com/blog/tag/devilspie.html"
SRC_URI="https://www.burtonini.com/computing/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libwnck:3"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	default

	sed -i "/doc\//s@devilspie..@${PF}/@" devilspie.1 || die
}
