# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Power manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-power-manager/start
	https://gitlab.xfce.org/xfce/xfce4-power-manager/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"
IUSE="networkmanager +panel-plugin policykit"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=sys-power/upower-0.99.0
	>=x11-libs/gtk+-3.24.0:3
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	>=x11-libs/libXrandr-1.2
	x11-libs/libXext
	x11-libs/libXtst
	>=xfce-base/xfconf-4.12:=
	>=xfce-base/libxfce4ui-4.18.2:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:=
	panel-plugin? ( >=xfce-base/xfce4-panel-4.12:= )
	policykit? ( >=sys-auth/polkit-0.112 )
"
RDEPEND="
	${DEPEND}
	networkmanager? ( net-misc/networkmanager )
"
DEPEND+="
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable policykit polkit)
		$(use_enable networkmanager network-manager)
		$(use_enable panel-plugin xfce4panel)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! has_version sys-apps/systemd && ! has_version sys-auth/elogind
	then
		elog "Suspend/hibernate support requires a logind provider installed"
		elog "(sys-apps/systemd or sys-auth/elogind)"
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
