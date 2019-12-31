# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/jaagr/polybar"

SRC_URI="https://github.com/polybar/polybar/releases/download/${PV}/${PN}-${PV}.tar"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

IUSE="alsa curl i3wm ipc mpd network pulseaudio"

DEPEND="
	x11-base/xcb-proto
	x11-libs/cairo[xcb]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	i3wm? ( dev-libs/jsoncpp )
	mpd? ( media-libs/libmpdclient )
	network? ( net-wireless/wireless-tools )
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/polybar

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
	-DENABLE_ALSA="$(usex alsa)"
	-DENABLE_CURL="$(usex curl)"
	-DENABLE_I3="$(usex i3wm)"
	-DBUILD_IPC_MSG="$(usex ipc)"
	-DENABLE_MPD="$(usex mpd)"
	-DENABLE_NETWORK="$(usex network)"
	-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
)

	cmake-utils_src_configure
}
