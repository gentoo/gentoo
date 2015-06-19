# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-power-manager/xfce4-power-manager-1.3.0.ebuild,v 1.8 2014/07/18 19:54:10 ago Exp $

EAPI=5
inherit linux-info multilib xfconf

DESCRIPTION="Power manager for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-power-manager"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="debug kernel_linux networkmanager policykit +udisks systemd +xfce_plugins_battery +xfce_plugins_brightness"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100.2
	>=dev-libs/glib-2.30
	>=sys-apps/dbus-1.6.18
	|| ( >=sys-power/upower-0.9.23 >=sys-power/upower-pm-utils-0.9.23-r2 )
	>=x11-libs/gtk+-2.24:2
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	>=x11-libs/libXrandr-1.2
	x11-libs/libXext
	>=xfce-base/xfconf-4.10
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	policykit? ( >=sys-auth/polkit-0.112 )
	xfce_plugins_battery? ( >=xfce-base/xfce4-panel-4.10 )
	xfce_plugins_brightness? ( >=xfce-base/xfce4-panel-4.10 )"
# USE="systemd" is for ensuring hibernate/suspend works by enforcing correct runtime -only dependencies
RDEPEND="${COMMON_DEPEND}
	networkmanager? ( net-misc/networkmanager )
	udisks? ( sys-fs/udisks:0 )
	!systemd? ( || ( sys-power/pm-utils sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-restore_brightness_level_after_sleep.patch )

	if use kernel_linux; then
		CONFIG_CHECK="~TIMER_STATS"
		linux-info_pkg_setup
	fi

	XFCONF=(
		$(use_enable policykit polkit)
		--enable-dpms
		$(use_enable networkmanager network-manager)
		$(xfconf_use_debug)
		)

	# TODO: Split --disable-panel-plugins to two separate AC_ARG_ENABLEs
	if ! use xfce_plugins_battery && ! use xfce_plugins_brightness; then
		XFCONF+=( --disable-panel-plugins )
	fi

	DOCS=( AUTHORS NEWS README TODO )
}

src_install() {
	xfconf_src_install

	if ! use xfce_plugins_battery; then
		rm -f \
			"${ED}"/usr/$(get_libdir)/xfce4/panel/plugins/libxfce4battery.* \
			"${ED}"/usr/share/xfce4/panel-plugins/xfce4-battery-plugin.desktop
	fi

	if ! use xfce_plugins_brightness; then
		rm -f \
			"${ED}"/usr/$(get_libdir)/xfce4/panel/plugins/libxfce4brightness.* \
			"${ED}"/usr/share/xfce4/panel-plugins/xfce4-brightness-plugin.desktop
	fi
}
