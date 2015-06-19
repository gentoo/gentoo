# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/colorhug-client/colorhug-client-0.2.5.ebuild,v 1.3 2015/03/15 13:27:40 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit bash-completion-r1 eutils gnome2

DESCRIPTION="Client tools for the ColorHug display colorimeter"
HOMEPAGE="http://www.hughski.com/"
SRC_URI="http://people.freedesktop.org/~hughsient/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.31.10:2
	>=dev-libs/libgusb-0.2.2
	media-libs/lcms:2
	>=media-libs/libcanberra-0.10[gtk3]
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3.11.2:3
	>=x11-misc/colord-1.2.6:0=
	>=x11-libs/colord-gtk-0.1.24
"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	app-text/yelp-tools
	>=dev-util/intltool-0.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
# docbook stuff needed for man pages

src_prepare() {
	# Fix .desktop
	sed -e '/Terminal=/ d' -i data/colorhug-docs.desktop || die

	gnome2_src_prepare
}

src_configure() {
	# introspection checked but not needed by anything
	gnome2_src_configure --disable-introspection
}

src_install() {
	gnome2_src_install bashcompletiondir="$(get_bashcompdir)"
}
