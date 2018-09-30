# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

XPP_VERSION="1.4.0"
I3IPCPP_VERSION="0.7.1"

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/jaagr/polybar"
SRC_URI="https://github.com/jaagr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/jaagr/xpp/archive/${XPP_VERSION}.tar.gz -> xpp-${XPP_VERSION}.tar.gz
	https://github.com/jaagr/i3ipcpp/archive/v${I3IPCPP_VERSION}.tar.gz -> i3ipcpp-${I3IPCPP_VERSION}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="alsa curl i3wm ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-util/cmake"

DEPEND="
	${PYTHON_DEPS}
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

src_prepare() {
	default

	rmdir "${S}"/lib/xpp || die
	mv "${WORKDIR}"/xpp-$XPP_VERSION "${S}"/lib/xpp || die

	rmdir "${S}"/lib/i3ipcpp || die
	mv "${WORKDIR}"/i3ipcpp-$I3IPCPP_VERSION "${S}"/lib/i3ipcpp || die

	sed -i "s/.*cpp_error,.*/&\n\t  'eventstruct'   : lambda x, y: None,/" lib/xpp/generators/cpp_client.py || die "sed failed"
}

src_configure() {
	local cmakeargs=(
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DENABLE_I3="$(usex i3wm)"
		-DBUILD_IPC_MSG="$(usex ipc)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
	)
	cmake . "${cmakeargs[@]}"
}
