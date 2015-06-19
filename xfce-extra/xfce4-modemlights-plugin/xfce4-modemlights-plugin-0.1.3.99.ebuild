# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-modemlights-plugin/xfce4-modemlights-plugin-0.1.3.99.ebuild,v 1.8 2012/11/28 12:25:10 ssuominen Exp $

EAPI=5
inherit multilib xfconf

DESCRIPTION="A panel plug-in intended to simplify establishing a ppp connection"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-modemlights-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
