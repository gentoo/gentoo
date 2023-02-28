# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Notification daemon for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/apps/notifyd/start
	https://gitlab.xfce.org/apps/xfce4-notifyd/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="sound wayland X"

DEPEND="
	>=dev-db/sqlite-3.34:3
	>=dev-libs/glib-2.68.0:2
	>=x11-libs/gtk+-3.22:3[wayland?,X?]
	>=x11-libs/libnotify-0.7
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfce4-panel-4.14.0:=
	>=xfce-base/xfconf-4.10:=
	sound? (
		>=media-libs/libcanberra-0.30[gtk3]
	)
	wayland? (
		>=gui-libs/gtk-layer-shell-0.7.0
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable wayland gdk-wayland)
		$(use_enable wayland gtk-layer-shell)
		$(use_enable X gdk-x11)
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
