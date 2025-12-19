# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson python-single-r1 xdg-utils

DESCRIPTION="Configuration system for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-settings/start
	https://gitlab.xfce.org/xfce/xfce4-settings/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="X colord input_devices_libinput libnotify upower wayland +xklavier"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( X wayland )
"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.0:3[X?,wayland?]
	>=xfce-base/garcon-4.18.0:=
	>=xfce-base/libxfce4ui-4.21.0:=[X?]
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/xfconf-4.19.3:=
	colord? ( >=x11-misc/colord-1.0.2:= )
	upower? ( >=sys-power/upower-0.99.10 )

	X? (
		>=media-libs/fontconfig-2.6.0
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXcursor-1.1.0
		>=x11-libs/libXext-1.0.0
		>=x11-libs/libXi-1.2.0
		>=x11-libs/libXrandr-1.5.0
		input_devices_libinput? ( >=x11-drivers/xf86-input-libinput-0.6.0 )
		libnotify? ( >=x11-libs/libnotify-0.7.8 )
		xklavier? ( >=x11-libs/libxklavier-5.0 )
	)
	wayland? (
		>=dev-libs/wayland-1.20
		>=gui-libs/gtk-layer-shell-0.7.0
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
# libxml2 for xmllint
BDEPEND="
	dev-libs/libxml2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://gitlab.xfce.org/xfce/xfce4-settings/-/issues/598
	"${FILESDIR}/${P}-helper-dir.patch"
)

src_prepare() {
	default
	python_fix_shebang dialogs/mime-settings/helpers/xfce4-compose-mail
}

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature libnotify)
		$(meson_feature xklavier libxklavier)
		$(meson_feature X xcursor)
		$(meson_feature input_devices_libinput xorg-libinput)
		$(meson_feature X xrandr)
		$(meson_feature wayland gtk-layer-shell)
		$(meson_feature upower)
		$(meson_feature colord)
		-Dsound-settings=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
