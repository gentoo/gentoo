# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE panel applet to display readings from hardware sensors"
LICENSE="GPL-2"
SLOT="0"

IUSE="+dbus gtk3 hddtemp libnotify lm_sensors video_cards_fglrx video_cards_nvidia"

RDEPEND="app-text/rarian:0
	>=dev-libs/glib-2.36:2
	>=mate-base/mate-panel-1.6[gtk3(-)=]
	>=x11-libs/cairo-1.0.4:0
	x11-libs/gdk-pixbuf:2
	virtual/libintl:0
	!gtk3? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( >=x11-libs/gtk+-3.0:3 )
	hddtemp? (
		dbus? (
			>=dev-libs/dbus-glib-0.80:0
			>=dev-libs/libatasmart-0.16:0 )
		!dbus? ( >=app-admin/hddtemp-0.3_beta13:0 ) )
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	lm_sensors? ( sys-apps/lm_sensors:0 )
	video_cards_fglrx? ( x11-drivers/ati-drivers:* )
	video_cards_nvidia? ( || (
		>=x11-drivers/nvidia-drivers-100.14.09:0[static-libs,tools]
		media-video/nvidia-settings:0
	) )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

PDEPEND="hddtemp? ( dbus? ( sys-fs/udisks:0 ) )"

src_configure() {
	local udisks

	if use hddtemp && use dbus; then
		udisks="--enable-udisks"
	else
		udisks="--disable-udisks"
	fi

	mate_src_configure \
		--disable-static \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable libnotify) \
		$(use_with lm_sensors libsensors) \
		$(use_with video_cards_fglrx aticonfig) \
		$(use_with video_cards_nvidia nvidia) \
		${udisks}
}
