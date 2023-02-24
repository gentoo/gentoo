# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Desktop manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfdesktop/start
	https://gitlab.xfce.org/xfce/xfdesktop/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~loong ~ppc ~riscv ~x86"
IUSE="libnotify +thunar wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=x11-libs/cairo-1.16
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3[wayland?,X?]
	x11-libs/libX11
	>=xfce-base/exo-0.11:=
	>=xfce-base/garcon-0.6:=
	>=xfce-base/libxfce4ui-4.13:=
	>=xfce-base/libxfce4util-4.13:=
	>=xfce-base/libxfce4windowing-4.19.1:=
	>=xfce-base/xfconf-4.12.1:=
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	thunar? ( >=xfce-base/thunar-4.17.10:= )
	wayland? ( >=gui-libs/gtk-layer-shell-0.7.0 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable wayland)
		$(use_enable wayland gtk-layer-shell)
		$(use_enable X x11)
		$(use_enable thunar file-icons)
		$(use_enable thunar thunarx)
		$(use_enable libnotify notifications)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
