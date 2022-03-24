# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A sticky note application for GTK"
HOMEPAGE="https://launchpad.net/xpad"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	app-accessibility/at-spi2-atk
	dev-libs/atk
	>=dev-libs/glib-2.58:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[X]
	x11-libs/gtksourceview:4
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/intltool-0.31
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}
