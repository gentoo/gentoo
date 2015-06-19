# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-settings/xfce4-settings-4.12.0.ebuild,v 1.1 2015/03/08 15:06:38 mgorny Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Configuration system for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug libcanberra libinput libnotify upower +xklavier"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.24
	media-libs/fontconfig
	>=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=x11-libs/libXcursor-1.1
	>=x11-libs/libXi-1.3
	>=x11-libs/libXrandr-1.2
	>=xfce-base/garcon-0.2
	>=xfce-base/exo-0.8
	>=xfce-base/libxfce4ui-4.11
	>=xfce-base/libxfce4util-4.11
	>=xfce-base/xfconf-4.10
	libcanberra? ( >=media-libs/libcanberra-0.25[sound] )
	libinput? ( x11-drivers/xf86-input-libinput )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	upower? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )
	xklavier? ( >=x11-libs/libxklavier-5 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	>=x11-proto/inputproto-1.4
	x11-proto/xproto"

pkg_setup() {
	XFCONF=(
		$(use_enable upower upower-glib)
		$(use_enable libinput xorg-libinput)
		$(use_enable libnotify)
		$(use_enable xklavier libxklavier)
		$(use_enable libcanberra sound-settings)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS TODO )
}
