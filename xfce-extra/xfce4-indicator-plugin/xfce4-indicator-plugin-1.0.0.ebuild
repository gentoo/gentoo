# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-indicator-plugin/xfce4-indicator-plugin-1.0.0.ebuild,v 1.1 2013/07/15 23:21:21 ssuominen Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A panel plugin that uses indicator-applet to show new messages"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-libs/libindicator-0.4:0
	>=x11-libs/gtk+-2.14:2
	x11-libs/libX11
	>=xfce-base/exo-0.6
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfce4-panel-4.8
	>=xfce-base/xfconf-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
