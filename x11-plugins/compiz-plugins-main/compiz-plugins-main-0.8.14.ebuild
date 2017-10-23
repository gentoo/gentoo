# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Compiz Window Manager: Plugins"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	gnome-base/librsvg
	virtual/jpeg:0
	virtual/glu
	>=x11-libs/compiz-bcop-0.7.3
	<x11-libs/compiz-bcop-0.9
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
	x11-libs/cairo
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
