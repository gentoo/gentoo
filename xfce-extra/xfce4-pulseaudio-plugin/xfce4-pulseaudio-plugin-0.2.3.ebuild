# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-pulseaudio-plugin/xfce4-pulseaudio-plugin-0.2.3.ebuild,v 1.3 2015/07/05 08:08:39 perfinion Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A panel plug-in for PulseAudio volume control"
HOMEPAGE="https://github.com/andrzej-r/xfce4-pulseaudio-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug keybinder libnotify"

RDEPEND=">=dev-libs/glib-2.24.0:=
	media-sound/pulseaudio:=
	>=x11-libs/gtk+-3.6.0:3=
	>=xfce-base/libxfce4ui-4.11.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.9.0:=
	>=xfce-base/xfce4-panel-4.11.0:=
	>=xfce-base/xfconf-4.6.0:=
	keybinder? ( dev-libs/keybinder:3= )
	libnotify? ( x11-libs/libnotify:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable keybinder)
		$(use_enable libnotify)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
