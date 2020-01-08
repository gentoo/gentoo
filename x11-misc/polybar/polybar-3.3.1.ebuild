# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-single-r1

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/jaagr/polybar"

if [[ ${PV} != *9999* ]]; then
	XPP_VERSION="1.4.0"
	I3IPCPP_VERSION="0.7.1"
	SRC_URI="https://github.com/jaagr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/jaagr/xpp/archive/${XPP_VERSION}.tar.gz -> xpp-${XPP_VERSION}.tar.gz
		https://github.com/jaagr/i3ipcpp/archive/v${I3IPCPP_VERSION}.tar.gz -> i3ipcpp-${I3IPCPP_VERSION}.tar.gz"
	KEYWORDS="amd64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jaagr/${PN}.git"
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

PATCHES=(
	"${FILESDIR}/${P}-eventstruct.patch"
	"${FILESDIR}/${P}-gcc9.patch"
	"${FILESDIR}/${P}-xpp-gcc9.patch"
	"${FILESDIR}/${P}-i3ipcpp-gcc9.patch"
)

src_prepare() {
	if [[ ${PV} != *9999* ]]; then
		rmdir "${S}"/lib/xpp || die
		mv "${WORKDIR}"/xpp-$XPP_VERSION "${S}"/lib/xpp || die

		rmdir "${S}"/lib/i3ipcpp || die
		mv "${WORKDIR}"/i3ipcpp-$I3IPCPP_VERSION "${S}"/lib/i3ipcpp || die
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
