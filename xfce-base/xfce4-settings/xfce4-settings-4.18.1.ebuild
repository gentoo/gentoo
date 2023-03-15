# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1 xdg-utils

DESCRIPTION="Configuration system for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-settings/start
	https://gitlab.xfce.org/xfce/xfce4-settings/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="colord input_devices_libinput libcanberra libnotify upower +xklavier"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.66.0
	media-libs/fontconfig
	>=x11-libs/gtk+-3.24.0:3
	x11-libs/libX11
	>=x11-libs/libXcursor-1.1
	>=x11-libs/libXi-1.3
	>=x11-libs/libXrandr-1.2
	>=xfce-base/garcon-0.2:=
	>=xfce-base/exo-4.15.1:=
	>=xfce-base/libxfce4ui-4.17.0:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfconf-4.13:=
	colord? ( x11-misc/colord:= )
	libcanberra? ( >=media-libs/libcanberra-0.25[sound] )
	input_devices_libinput? ( x11-drivers/xf86-input-libinput )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	upower? ( >=sys-power/upower-0.9.23 )
	xklavier? ( >=x11-libs/libxklavier-5 )
	!<xfce-base/exo-4.15.1
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	local myconf=(
		$(use_enable upower upower-glib)
		$(use_enable input_devices_libinput xorg-libinput)
		$(use_enable libnotify)
		$(use_enable colord)
		$(use_enable xklavier libxklavier)
		$(use_enable libcanberra sound-settings)
	)
	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
