# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="configurable talking graphical cow (inspired by cowsay)"
HOMEPAGE="http://www.doof.me.uk/xcowsay/"
SRC_URI="http://www.nickg.me.uk/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus fortune"

RDEPEND="dbus? ( sys-apps/dbus )
	dev-libs/dbus-glib
	fortune? ( games-misc/fortune-mod )
	media-libs/freetype:2
	media-libs/libpng
	x11-libs/pango
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable dbus)
}

src_install() {
	default
	if ! use fortune; then
		rm -f "${D}"/usr/bin/xcowfortune
	fi
}
