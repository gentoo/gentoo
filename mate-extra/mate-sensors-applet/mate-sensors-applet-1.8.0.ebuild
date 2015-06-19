# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-extra/mate-sensors-applet/mate-sensors-applet-1.8.0.ebuild,v 1.4 2014/07/02 09:48:12 pacho Exp $

EAPI="5"

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 eutils versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE panel applet to display readings from hardware sensors"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="+dbus hddtemp libnotify lm_sensors video_cards_fglrx video_cards_nvidia"

RDEPEND="app-text/rarian:0
	>=dev-libs/glib-2.26:2
	>=mate-base/mate-panel-1.6:0
	>=x11-libs/cairo-1.0.4:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.14:2
	virtual/libintl:0
	hddtemp? (
		dbus? (
			>=dev-libs/dbus-glib-0.80:0
			>=dev-libs/libatasmart-0.16:0 )
		!dbus? ( >=app-admin/hddtemp-0.3_beta13:0 ) )
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	lm_sensors? ( sys-apps/lm_sensors:0 )
	video_cards_fglrx? ( x11-drivers/ati-drivers:* )
	video_cards_nvidia? ( || (
		>=x11-drivers/nvidia-drivers-100.14.09:0
		media-video/nvidia-settings:0
	) )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	dev-util/intltool:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

# Requires libxslt only for use by gnome-doc-utils.
PDEPEND="hddtemp? ( dbus? ( sys-fs/udisks:0 ) )"

src_configure() {
	local myconf

	if use hddtemp && use dbus; then
		myconf="${myconf} $(use_enable dbus udisks)"
	else
		myconf="${myconf} --disable-udisks"
	fi

	gnome2_src_configure \
		--disable-static \
		$(use_enable libnotify) \
		$(use_with lm_sensors libsensors) \
		$(use_with video_cards_fglrx aticonfig) \
		$(use_with video_cards_nvidia nvidia) \
		${myconf}
}

DOCS="AUTHORS ChangeLog NEWS README TODO"
