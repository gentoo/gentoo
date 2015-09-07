# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://wiki.gnome.org/Projects/Zenity"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="libnotify test +webkit"

RDEPEND="
	>=dev-libs/glib-2.8:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3
	x11-libs/libX11
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.6.1:= )
	webkit? ( >=net-libs/webkit-gtk-2.8.1:4 )
"
DEPEND="${RDEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	test? ( app-text/yelp-tools )
"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2.12

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"

	gnome2_src_configure \
		$(use_enable libnotify) \
		$(use_enable webkit webkitgtk) \
		PERL=$(type -P false)
}

src_install() {
	gnome2_src_install

	# Not really needed and prevent us from needing perl
	rm "${ED}/usr/bin/gdialog" || die "rm gdialog failed!"
}
