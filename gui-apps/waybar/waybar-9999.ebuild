# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Highly customizable Wayland bar for Sway and Wlroots based compositors"
HOMEPAGE="https://github.com/Alexays/Waybar"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Alexays/${PN^}.git"
else
	SRC_URI="https://github.com/Alexays/${PN^}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="mpd network popups pulseaudio tray +udev"

BDEPEND="
	>=app-text/scdoc-1.9.2
	virtual/pkgconfig
	"
DEPEND="
	dev-cpp/gtkmm:3.0
	dev-libs/jsoncpp:=
	dev-libs/libinput:=
	dev-libs/libsigc++:2
	>=dev-libs/libfmt-5.3.0:=
	>=dev-libs/spdlog-1.3.1:=
	dev-libs/date:=
	dev-libs/wayland
	dev-libs/wayland-protocols
	gui-libs/wlroots
	x11-libs/gtk+:3[wayland]
	mpd? ( media-libs/libmpdclient )
	network? ( dev-libs/libnl:3 )
	popups? ( gui-libs/gtk-layer-shell )
	pulseaudio? ( media-sound/pulseaudio )
	tray? (
		dev-libs/libdbusmenu[gtk3]
		dev-libs/libappindicator
	)
	udev? ( virtual/libudev:= )
	"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature mpd)
		$(meson_feature network libnl)
		$(meson_feature popups gtk-layer-shell)
		$(meson_feature pulseaudio)
		$(meson_feature tray dbusmenu-gtk)
		$(meson_feature udev libudev)
	)
	meson_src_configure
}
