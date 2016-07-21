# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="Music Player Daemon (mpd) panel plugin"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-mpc-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug libmpd"

RDEPEND=">=xfce-base/exo-0.6
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/xfce4-panel-4.8
	libmpd? ( media-libs/libmpd )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable libmpd)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog README TODO )
}
