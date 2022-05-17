# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man +swaybar +swaybg +swayidle +swaylock +swaymsg +swaynag tray wallpapers X"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	sys-auth/seatd:=
	dev-libs/libpcre
	>=dev-libs/wayland-1.20.0
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	media-libs/mesa[gles2,libglvnd(+)]
	swaybar? ( x11-libs/gdk-pixbuf:2 )
	swaybg? ( gui-apps/swaybg )
	swayidle? ( gui-apps/swayidle )
	swaylock? ( gui-apps/swaylock )
	tray? ( || (
		sys-apps/systemd
		sys-auth/elogind
		sys-libs/basu
	) )
	wallpapers? ( x11-libs/gdk-pixbuf:2[jpeg] )
	X? ( x11-libs/libxcb:0= )
"
if [[ ${PV} == 9999 ]]; then
	DEPEND+="~gui-libs/wlroots-9999:=[X=]"
else
	DEPEND+="
		>=gui-libs/wlroots-0.15:=[X=]
		<gui-libs/wlroots-0.16:=[X=]
	"
fi
RDEPEND="
	x11-misc/xkeyboard-config
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.24
	>=dev-util/meson-0.60.0
	virtual/pkgconfig
"
if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( >=app-text/scdoc-1.9.3 )"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature tray)
		$(meson_feature X xwayland)
		$(meson_feature swaybar gdk-pixbuf)
		$(meson_use swaynag)
		$(meson_use swaybar)
		$(meson_use wallpapers default-wallpaper)
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
	)

	meson_src_configure
}
