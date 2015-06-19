# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-power-manager/xfce4-power-manager-1.5.0.ebuild,v 1.1 2015/05/26 07:34:18 mgorny Exp $

EAPI=5
inherit linux-info xfconf

DESCRIPTION="Power manager for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-power-manager"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="debug kernel_linux networkmanager policykit +xfce_plugins_power"

COMMON_DEPEND=">=dev-libs/glib-2.42:=
	>=sys-power/upower-0.99.0
	>=x11-libs/gtk+-3.14:3=
	>=x11-libs/libnotify-0.7
	x11-libs/libX11:=
	>=x11-libs/libXrandr-1.2:=
	x11-libs/libXext:=
	>=xfce-base/xfconf-4.12:=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:=
	policykit? ( >=sys-auth/polkit-0.112 )
	xfce_plugins_power? ( >=xfce-base/xfce4-panel-4.12:= )"
RDEPEND="${COMMON_DEPEND}
	networkmanager? ( net-misc/networkmanager )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~TIMER_STATS"
		linux-info_pkg_setup
	fi

	XFCONF=(
		$(use_enable policykit polkit)
		$(use_enable networkmanager network-manager)
		$(use_enable xfce_plugins_power xfce4panel)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS NEWS README TODO )
}
