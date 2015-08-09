# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="caja nfs policykit samba"

RDEPEND="app-text/rarian:0
	>=app-admin/system-tools-backends-2.10.1:0
	dev-libs/atk:0
	dev-libs/dbus-glib:0
	>=dev-libs/glib-2.25.3:2
	>=dev-libs/liboobs-1.1:0
	>=sys-apps/dbus-0.32:0
	net-wireless/wireless-tools:0
	sys-libs/cracklib:0
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:0
	>=x11-libs/gtk+-2.19.7:2
	virtual/libintl:0
	caja? ( >=mate-base/caja-1.8:0 )
	nfs? ( net-fs/nfs-utils:0 )
	policykit? (
		>=mate-extra/mate-polkit-1.8:0
		>=sys-auth/polkit-0.92:0
	)
	samba? ( >=net-fs/samba-3:0 )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	sys-devel/gettext:*
	virtual/pkgconfig:*
	>=dev-util/intltool-0.35.0:*"

src_configure() {
	local myconf
	if ! use nfs && ! use samba; then
		myconf="--disable-shares"
	fi

	gnome2_src_configure \
		${myconf} \
		--disable-static \
		$(use_enable policykit polkit-gtk-mate) \
		$(use_enable caja)
}

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"
