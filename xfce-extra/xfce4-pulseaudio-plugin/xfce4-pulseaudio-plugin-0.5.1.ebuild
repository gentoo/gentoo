# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A panel plug-in for PulseAudio volume control"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/
"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+keybinder libcanberra libnotify"

# TODO: remove exo when we dep on >=libxfce4ui-4.21.0
DEPEND="
	>=dev-libs/glib-2.50.0
	>=media-libs/libpulse-0.9.19:=[glib]
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/exo-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/libxfce4windowing-4.19.6:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	keybinder? ( >=dev-libs/keybinder-0.2.2:3 )
	libcanberra? ( >=media-libs/libcanberra-0.30 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature keybinder)
		$(meson_feature libcanberra)
		$(meson_feature libnotify)
		-Dlibxfce4windowing=enabled
		-Dmpris2=enabled
	)

	meson_src_configure
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
