# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A clipboard manager plug-in for the Xfce panel"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-clipman-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-clipman-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="X qrcode wayland"
REQUIRED_USE="|| ( X wayland )"

DEPEND="
	>=dev-libs/glib-2.60.0
	>=x11-libs/gtk+-3.22.29:3[wayland?,X?]
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXtst-1.0.0
	)
	qrcode? ( >=media-gfx/qrencode-3.3.0:= )
	wayland? (
		>=dev-libs/wayland-1.15.0
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	X? (
		>=x11-base/xorg-proto-7.0.0
	)
	wayland? (
		>=dev-util/wayland-scanner-1.15.0
	)
"

src_configure() {
	local myconf=(
		$(use_enable qrcode libqrencode)

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
}

pkg_postrm() {
	xdg_icon_cache_update
}
