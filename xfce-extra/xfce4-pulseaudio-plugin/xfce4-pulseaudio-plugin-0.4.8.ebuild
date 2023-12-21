# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A panel plug-in for PulseAudio volume control"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/
"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv x86"
# TODO: remove wnck when libxfce4windowing is ready to go stable
IUSE="+keybinder libcanberra libnotify libxfce4windowing wnck"
REQUIRED_USE="?? ( libxfce4windowing wnck )"

DEPEND="
	>=dev-libs/glib-2.44.0
	media-libs/libpulse:=[glib]
	>=x11-libs/gtk+-3.20.0:3
	>=xfce-base/exo-0.11:=
	>=xfce-base/libxfce4ui-4.11.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.9.0:=
	>=xfce-base/xfce4-panel-4.11.0:=
	>=xfce-base/xfconf-4.6.0:=
	keybinder? ( dev-libs/keybinder:3 )
	libcanberra? ( media-libs/libcanberra )
	libnotify? ( x11-libs/libnotify )
	libxfce4windowing? ( xfce-base/libxfce4windowing:= )
	wnck? ( x11-libs/libwnck:3 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable keybinder)
		$(use_enable libcanberra)
		$(use_enable libnotify)
		$(use_enable libxfce4windowing)
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
