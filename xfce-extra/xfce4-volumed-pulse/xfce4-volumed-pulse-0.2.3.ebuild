# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Daemon to control volume up/down and mute keys for pulseaudio"
HOMEPAGE="https://git.xfce.org/apps/xfce4-volumed-pulse/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND=">=dev-libs/glib-2.16:2=
	dev-libs/keybinder:3=
	>=media-sound/pulseaudio-0.9.19:=[glib]
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/xfconf-4.8:=
	libnotify? ( x11-libs/libnotify:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable libnotify)
	)

	econf "${myconf[@]}"
}
