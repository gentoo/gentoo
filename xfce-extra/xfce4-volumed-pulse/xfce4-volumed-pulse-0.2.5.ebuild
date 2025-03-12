# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Daemon to control volume up/down and mute keys for pulseaudio"
HOMEPAGE="https://gitlab.xfce.org/apps/xfce4-volumed-pulse/"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv x86"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.26.0
	dev-libs/keybinder:3
	media-libs/libpulse[glib]
	>=x11-libs/gtk+-3.20.0:3
	>=xfce-base/xfconf-4.8.0:=
	libnotify? ( x11-libs/libnotify )
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
		$(use_enable libnotify)
	)

	econf "${myconf[@]}"
}
