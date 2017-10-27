# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="flickr applications for GNOME"
HOMEPAGE="https://live.gnome.org/Frogr"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.44
	>=x11-libs/gtk+-3.10:3[introspection]
	>=media-libs/libexif-0.6.14
	>=dev-libs/libxml2-2.6.8
	>=media-libs/gstreamer-1.0
	>=net-libs/libsoup-2.34
	>=dev-libs/libgcrypt-1.5.0:*
"

DEPEND="${RDEPEND}
"
