# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A small v4l frame capture utility especially suited for stop motion animation"
SRC_URI="http://frameworks.polycrystal.org/release/${P}.tar.gz"
HOMEPAGE="http://frameworks.polycrystal.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=gnome-base/libglade-2
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(
	AUTHORS ChangeLog NEWS README TODO
)
PATCHES=(
	"${FILESDIR}"/${PN}-0.3.7-ceilf.patch
	"${FILESDIR}"/${PN}-0.3.7-strcmp-and-datadir.patch
)

src_prepare() {
	default

	eautoreconf
}
