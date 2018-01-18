# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://wiki.gnome.org/Projects/Zenity"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug libnotify webkit"

# TODO: X11 dependency is automagically enabled
RDEPEND="
	>=dev-libs/glib-2.8:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3[X]
	x11-libs/libX11
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.6.1:= )
	webkit? ( >=net-libs/webkit-gtk-2.8.1:4 )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	gnome-base/gnome-common
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable libnotify) \
		$(use_enable webkit webkitgtk) \
		PERL=$(type -P false)
}

src_install() {
	gnome2_src_install

	# Not really needed and prevent us from needing perl
	rm "${ED}/usr/bin/gdialog" || die "rm gdialog failed!"
}
