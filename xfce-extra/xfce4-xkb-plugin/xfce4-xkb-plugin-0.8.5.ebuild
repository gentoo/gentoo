# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="XKB layout switching panel plug-in for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-xkb-plugin
	https://gitlab.xfce.org/panel-plugins/xfce4-xkb-plugin/
"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=gnome-base/librsvg-2.40
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libwnck-3.14:3
	x11-libs/libX11
	>=x11-libs/libxklavier-5.3
	>=xfce-base/garcon-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
RDEPEND="
	${DEPEND}
	x11-apps/setxkbmap
	>=xfce-base/xfce4-settings-4.11
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable libnotify)
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
