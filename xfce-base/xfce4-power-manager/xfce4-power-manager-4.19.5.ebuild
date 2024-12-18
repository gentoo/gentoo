# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="+panel-plugin policykit wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=sys-power/upower-0.99.10
	>=x11-libs/gtk+-3.24.0:3[wayland?,X?]
	>=x11-libs/libnotify-0.7.0
	>=xfce-base/xfconf-4.12:=
	>=xfce-base/libxfce4ui-4.18.4:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.19.2:=
	panel-plugin? ( >=xfce-base/xfce4-panel-4.14.0:= )
	policykit? ( >=sys-auth/polkit-0.102 )
	wayland? (
		>=dev-libs/wayland-1.20
	)
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXrandr-1.5.0
		>=x11-libs/libXext-1.0.0
		x11-libs/libXtst
	)
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	wayland? (
		>=dev-libs/wayland-protocols-1.25
		>=dev-util/wayland-scanner-1.20
	)
"

src_configure() {
	local myconf=(
		$(use_enable policykit polkit)
		$(use_enable panel-plugin xfce4panel)
		$(use_enable wayland)
		$(use_enable X x11)
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
