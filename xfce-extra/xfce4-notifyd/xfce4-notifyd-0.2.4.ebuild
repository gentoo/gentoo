# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-notifyd/xfce4-notifyd-0.2.4.ebuild,v 1.4 2014/01/28 14:17:53 ago Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Notification daemon for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-notifyd"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=sys-apps/dbus-1.6
	>=x11-libs/gtk+-2.14:2
	>=x11-libs/libnotify-0.7
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfconf-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=( $(xfconf_use_debug) )
	DOCS=( AUTHORS NEWS README TODO )
}
