# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Power manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-power-manager/start
	https://gitlab.xfce.org/xfce/xfce4-power-manager/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="+panel-plugin policykit wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=sys-power/upower-0.99.10
	>=x11-libs/gtk+-3.24.0:3[wayland?,X?]
	>=x11-libs/libnotify-0.7.8
	>=xfce-base/xfconf-4.18.0:=
	>=xfce-base/libxfce4ui-4.21.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.19.4:=
	panel-plugin? ( >=xfce-base/xfce4-panel-4.18.0:= )
	policykit? ( >=sys-auth/polkit-0.102 )
	wayland? (
		>=dev-libs/wayland-1.20
	)
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXrandr-1.5.0
		>=x11-libs/libXext-1.0.0
	)
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	x11-base/xorg-proto
	wayland? (
		>=dev-libs/wayland-protocols-1.25
	)
"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	wayland? (
		>=dev-util/wayland-scanner-1.20
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature panel-plugin)
		$(meson_feature policykit polkit)
	)
	meson_src_configure
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
