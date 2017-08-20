# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="a simple media player based on the GStreamer framework for the Xfce4 desktop"
HOMEPAGE="https://docs.xfce.org/apps/parole/start"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="clutter debug libnotify taglib"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100:=
	>=dev-libs/glib-2.32:2=
	media-libs/gstreamer:1.0=
	media-libs/gst-plugins-base:1.0=
	sys-apps/dbus:0=
	>=x11-libs/gtk+-3.2:3=
	x11-libs/libX11:0=
	>=xfce-base/libxfce4ui-4.11:0=[gtk3(+)]
	>=xfce-base/libxfce4util-4.11:0=
	>=xfce-base/xfconf-4.10:0=
	clutter? (
		>=media-libs/clutter-1.16.4:1.0=
		>=media-libs/clutter-gtk-1.4.4:1.0=
		)
	libnotify? ( >=x11-libs/libnotify-0.7:0= )
	taglib? ( >=media-libs/taglib-1.6:0= )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	XFCONF=(
		$(use_enable clutter)
		$(use_enable taglib)
		$(use_enable libnotify notify-plugin)
		$(xfconf_use_debug)
		--with-gstreamer=1.0
		)

	DOCS=( AUTHORS ChangeLog README THANKS TODO )
}
