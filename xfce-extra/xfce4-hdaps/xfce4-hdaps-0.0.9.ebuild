# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-hdaps/xfce4-hdaps-0.0.9.ebuild,v 1.3 2012/11/28 12:25:31 ssuominen Exp $

EAPI=5
inherit linux-info xfconf

DESCRIPTION="A plugin to indicate the status of the IBM Hard Drive Active Protection System"
HOMEPAGE="http://michael.orlitzky.com/code/xfce4-hdaps.php"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfce4-panel-4.8"
RDEPEND="${COMMON_DEPEND}
	>=app-laptop/hdapsd-20090101
	>=app-laptop/tp_smapi-0.39"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog README TODO )

	linux-info_pkg_setup

	if kernel_is lt 2 6 28; then
		echo
		ewarn "Unsupported kernel detected. Upgrade to 2.6.28 or above."
		echo
	fi
}
