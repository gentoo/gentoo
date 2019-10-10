# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A panel plug-in for PulseAudio volume control"
HOMEPAGE="https://git.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug keybinder libnotify wnck"

RDEPEND=">=dev-libs/glib-2.42.0:=
	media-sound/pulseaudio:=
	>=x11-libs/gtk+-3.20.0:3=
	>=xfce-base/libxfce4ui-4.11.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.9.0:=
	>=xfce-base/xfce4-panel-4.11.0:=
	>=xfce-base/xfconf-4.6.0:=
	keybinder? ( dev-libs/keybinder:3= )
	libnotify? ( x11-libs/libnotify:= )
	wnck? ( x11-libs/libwnck:3= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable keybinder)
		$(use_enable libnotify)
		$(use_enable wnck)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! has_version media-sound/pavucontrol; then
		elog "For the 'audio mixer...' shortcut to work, you need to install"
		elog "an external mixer application. Please either install:"
		elog
		elog "	media-sound/pavucontrol"
		elog
		elog "or specify another application to use in the 'Properties' dialog."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
