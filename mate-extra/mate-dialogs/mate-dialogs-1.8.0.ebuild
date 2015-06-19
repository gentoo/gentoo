# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-extra/mate-dialogs/mate-dialogs-1.8.0.ebuild,v 1.4 2014/07/02 09:47:33 pacho Exp $

EAPI="5"

GCONF_DEBUG="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Display MATE dialogs from the commandline and shell scripts"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="libnotify"

RDEPEND="app-text/rarian:0
	>=dev-libs/glib-2.8:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.18:2
	x11-libs/libX11:0
	virtual/libintl:0
	libnotify? ( >=x11-libs/libnotify-0.7.0:0 )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	>=dev-util/intltool-0.40:*
	>=mate-base/mate-common-1.6:0
	>=sys-devel/gettext-0.14:*
	virtual/pkgconfig:*"

src_configure() {
	gnome2_src_configure \
		--with-gtk=2.0 \
		$(use_enable libnotify)
}

DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"
