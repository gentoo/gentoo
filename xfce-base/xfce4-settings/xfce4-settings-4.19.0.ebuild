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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="colord input_devices_libinput libcanberra libnotify upower +xklavier"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.66.0
	>=media-libs/fontconfig-2.6.0
	>=x11-libs/gtk+-3.24.0:3
	>=x11-libs/libX11-1.6.7
	>=x11-libs/libXcursor-1.1.0
	>=x11-libs/libXi-1.2.0
	>=x11-libs/libXrandr-1.2.0
	>=xfce-base/garcon-0.1.10:=
	>=xfce-base/exo-0.11.0:=
	>=xfce-base/libxfce4ui-4.17.0:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfconf-4.13.0:=
	colord? ( >=x11-misc/colord-1.0.2:= )
	libcanberra? ( >=media-libs/libcanberra-0.25[sound] )
	input_devices_libinput? ( >=x11-drivers/xf86-input-libinput-0.6.0 )
	libnotify? ( >=x11-libs/libnotify-0.1.3 )
	upower? ( >=sys-power/upower-0.9.8 )
	xklavier? ( >=x11-libs/libxklavier-5.0 )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
# libxml2 for xmllint
BDEPEND="
	dev-libs/libxml2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
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
