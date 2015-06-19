# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/parole/parole-0.6.1.ebuild,v 1.2 2015/05/11 17:18:31 mgorny Exp $

EAPI=5
inherit xfconf

DESCRIPTION="a simple media player based on the GStreamer framework for the Xfce4 desktop"
HOMEPAGE="http://goodies.xfce.org/projects/applications/parole/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="debug libnotify taglib"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.32
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	sys-apps/dbus
	>=x11-libs/gtk+-3.2:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.11[gtk3(+)]
	>=xfce-base/libxfce4util-4.11
	>=xfce-base/xfconf-4.10
	libnotify? ( >=x11-libs/libnotify-0.7 )
	taglib? ( >=media-libs/taglib-1.6 )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	XFCONF=(
		$(use_enable taglib)
		$(use_enable libnotify notify-plugin)
		$(xfconf_use_debug)
		--with-gstreamer=1.0
		)

	DOCS=( AUTHORS ChangeLog README THANKS TODO )
}
