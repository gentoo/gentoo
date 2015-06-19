# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfdashboard/xfdashboard-0.4.0.ebuild,v 1.1 2015/04/14 22:12:19 mgorny Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Maybe a GNOME shell like dashboard for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfdashboard/start"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-libs/dbus-glib-0.100:=
	>=dev-libs/glib-2.32:=
	>=x11-libs/gtk+-3.2:3=
	>=media-libs/clutter-1.12:1.0=
	>=x11-libs/libwnck-3:3=
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXdamage:=
	x11-libs/libXinerama:=
	>=xfce-base/garcon-0.2.0:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS="AUTHORS ChangeLog README"
}
