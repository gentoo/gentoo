# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="A panel plug-in to control MPRIS2 compatible players like Pragha (from the same authors)"
HOMEPAGE="http://github.com/matiasdelellis/xfce4-soundmenu-plugin"
SRC_URI="http://github.com/matiasdelellis/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +glyr lastfm +keybinder"

RDEPEND=">=dev-libs/glib-2.28
	>=media-libs/libmpris2client-0.1
	>=media-sound/pulseaudio-2[glib]
	>=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	glyr? ( >=media-libs/glyr-1.0.0 )
	lastfm? ( >=media-libs/libclastfm-0.5 )
	keybinder? ( >=dev-libs/keybinder-0.2.2:0 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable keybinder)
		$(use_enable lastfm libclastfm)
		$(use_enable glyr libglyr)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
}
