# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2 git-r3

DESCRIPTION="GNOME MUD client"
HOMEPAGE="https://wiki.gnome.org/Apps/GnomeMud"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-mud.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug gstreamer"

RDEPEND="
	>=dev-libs/glib-2.48:2
	>=x11-libs/gtk+-2.24.0:2
	>=x11-libs/vte-0.11:0
	dev-libs/libpcre
	sys-libs/zlib
	gstreamer? ( media-libs/gstreamer:1.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/rarian
	>=dev-util/intltool-0.35.0
	>=sys-devel/gettext-0.11.5"

src_configure() {
	gnome2_src_configure \
		--enable-mccp \
		$(use_enable gstreamer) \
		$(use_enable debug debug-logger)
}

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS README ROADMAP" \
		gnome2_src_install
}

pkg_preinst() {
	gnome2_pkg_preinst
}
