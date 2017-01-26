# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_MIN_API_VERSION="0.24"

inherit gnome2 vala

DESCRIPTION="Disassemble a pile of tiles by removing matching pairs"
HOMEPAGE="https://wiki.gnome.org/Apps/Mahjongg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32:2
	>=x11-libs/gtk+-3.13.2:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
