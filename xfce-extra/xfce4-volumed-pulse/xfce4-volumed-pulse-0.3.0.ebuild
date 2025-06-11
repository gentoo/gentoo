# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Daemon to control volume up/down and mute keys for pulseaudio"
HOMEPAGE="https://gitlab.xfce.org/apps/xfce4-volumed-pulse/"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv x86"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=dev-libs/keybinder-0.2.0:3
	>=media-libs/libpulse-0.9.19[glib]
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/xfconf-4.18.0:=
	libnotify? ( >=x11-libs/libnotify-0.1.3 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(meson_feature libnotify)
	)

	meson_src_configure
}
