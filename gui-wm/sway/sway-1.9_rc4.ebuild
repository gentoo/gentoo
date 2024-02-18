# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man +swaybar +swaynag tray wallpapers X"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.21.0:0=
	virtual/libudev
	sys-auth/seatd:=
	dev-libs/libpcre2
	>=dev-libs/wayland-1.20.0
	x11-libs/cairo
	>=x11-libs/libxkbcommon-1.5.0:0=
	x11-libs/pango
	x11-libs/pixman
	media-libs/mesa[gles2,libglvnd(+)]
	swaybar? ( x11-libs/gdk-pixbuf:2 )
	tray? ( || (
		sys-apps/systemd
		sys-auth/elogind
		sys-libs/basu
	) )
	wallpapers? ( gui-apps/swaybg[gdk-pixbuf(+)] )
	X? (
		x11-libs/libxcb:0=
		x11-libs/xcb-util-wm
	)
"
# x11-libs/xcb-util-wm needed for xcb-iccm
if [[ ${PV} == 9999 ]]; then
	DEPEND+="~gui-libs/wlroots-9999:=[X?]"
else
	DEPEND+="
		>=gui-libs/wlroots-0.17:=[X?]
		<gui-libs/wlroots-0.18:=[X?]
	"
fi
RDEPEND="
	x11-misc/xkeyboard-config
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.24
	>=dev-build/meson-0.60.0
	virtual/pkgconfig
"
if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( >=app-text/scdoc-1.9.3 )"
fi
REQUIRED_USE="tray? ( swaybar )"

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

src_install() {
	meson_src_install
	insinto /usr/share/xdg-desktop-portal
	doins "${FILESDIR}/sway-portals.conf"
}

pkg_postinst() {
	optfeature_header "There are several packages that may be useful with sway:"
	optfeature "wallpaper utility" gui-apps/swaybg
	optfeature "idle management utility" gui-apps/swayidle
	optfeature "simple screen locker" gui-apps/swaylock
	optfeature "lightweight notification daemon" gui-apps/mako
	echo
	einfo "For a list of additional addons and tools usable with sway please"
	einfo "visit the offical wiki at:"
	einfo "https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway"
	einfo "Please note that some of them might not (yet) available on gentoo"
}
