# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-wavelan-plugin/xfce4-wavelan-plugin-0.5.11.ebuild,v 1.4 2012/11/28 12:23:52 ssuominen Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A panel plug-in to display wireless interface statistics"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-wavelan-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="debug kernel_linux"

COMMON_DEPEND=">=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfce4-panel-4.8"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/net-tools )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
