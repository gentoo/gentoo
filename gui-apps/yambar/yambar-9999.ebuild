# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/dnkl/${PN}.git"
else
	SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Modular status panel for X11 and Wayland, inspired by polybar"
HOMEPAGE="https://codeberg.org/dnkl/yambar"
LICENSE="MIT"
SLOT="0"
IUSE="X +alsa mpd pipewire pulseaudio test +udev wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( wayland X )
	test? ( alsa mpd udev )
"

RDEPEND="
	dev-libs/libyaml
	media-libs/fcft
	dev-libs/json-c:=
	x11-libs/pixman
	alsa? ( media-libs/alsa-lib )
	mpd? ( media-libs/libmpdclient )
	pipewire? ( media-video/pipewire )
	pulseaudio? ( media-libs/libpulse )
	udev? ( virtual/libudev )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-wm
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/tllist
"
BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
	wayland? (
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
	)
"

src_configure() {
	local -a emesonargs=(
		$(meson_feature wayland backend-wayland)
		$(meson_feature X backend-x11)

		-Dcore-plugins-as-shared-libraries=false

		$(meson_feature udev plugin-backlight)
		$(meson_feature udev plugin-battery)
		$(meson_feature udev plugin-removables)

		$(meson_feature alsa plugin-alsa)
		$(meson_feature mpd plugin-mpd)
		$(meson_feature pipewire plugin-pipewire)
		$(meson_feature pulseaudio plugin-pulse)

		$(meson_feature wayland plugin-foreign-toplevel)
		$(meson_feature wayland plugin-river)

		$(meson_feature X plugin-xkb)
		$(meson_feature X plugin-xwindow)

		# These plugins does not add additional dependencies
		# i3 and sway-xkb plugins don't depend on xcb/wayland
		-Dplugin-clock=enabled
		-Dplugin-cpu=enabled
		-Dplugin-disk-io=enabled
		-Dplugin-dwl=enabled
		-Dplugin-i3=enabled
		-Dplugin-label=enabled
		-Dplugin-mem=enabled
		-Dplugin-network=enabled
		-Dplugin-script=enabled
		-Dplugin-sway-xkb=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc CHANGELOG.md
	rm -r "${ED}/usr/share/doc/${PN}" || die
}
