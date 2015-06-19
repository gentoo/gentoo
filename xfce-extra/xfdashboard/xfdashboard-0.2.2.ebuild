# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfdashboard/xfdashboard-0.2.2.ebuild,v 1.1 2014/08/20 12:24:12 ssuominen Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Maybe a GNOME shell like dashboard for the Xfce desktop environment"
HOMEPAGE="http://xfdashboard.froevel.de/"
SRC_URI="http://${PN}.froevel.de/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2
	>=media-libs/clutter-1.12:1.0
	>=x11-libs/libwnck-2.30:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	>=xfce-base/garcon-0.2.0
	>=xfce-base/xfconf-4.10"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS="AUTHORS ChangeLog README"
}
