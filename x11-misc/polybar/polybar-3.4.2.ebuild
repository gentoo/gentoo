# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-utils python-single-r1

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/polybar/polybar"

if [[ ${PV} != *9999* ]]; then
	# These are the commits
	XPP_COMMIT="f70dd8bb50944ab64ab902d9d8ab555599249dc1"
	I3IPCPP_COMMIT="21ce9060ac7c502225fdbd2f200b1cbdd8eca08d"
	SRC_URI="https://github.com/polybar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/polybar/xpp/archive/${XPP_COMMIT}.tar.gz -> xpp-${XPP_COMMIT}.tar.gz
		https://github.com/polybar/i3ipcpp/archive/${I3IPCPP_COMMIT}.tar.gz -> i3ipcpp-${I3IPCPP_COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/polybar/${PN}.git"
	EGIT_CLONE_TYPE="shallow"
fi

LICENSE="MIT"
SLOT="0"

IUSE="alsa curl i3wm ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

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
	if [[ ${PV} != *9999* ]]; then
		rmdir "${S}"/lib/xpp || die
		mv "${WORKDIR}"/xpp-$XPP_COMMIT "${S}"/lib/xpp || die

		rmdir "${S}"/lib/i3ipcpp || die
		mv "${WORKDIR}"/i3ipcpp-$I3IPCPP_COMMIT "${S}"/lib/i3ipcpp || die
	fi

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
