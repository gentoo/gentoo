# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
XPP_COMMIT="044e69d05db7f89339bda1ccd1efe0263b01c8f6"
I3IPCPP_COMMIT="cb008b30fc5f3febfe467884cb0211ee3c16386b"

inherit cmake python-single-r1

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/polybar/polybar"
SRC_URI="https://github.com/polybar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/polybar/xpp/archive/${XPP_COMMIT}.tar.gz -> xpp-${XPP_COMMIT}.tar.gz
	https://github.com/polybar/i3ipcpp/archive/${I3IPCPP_COMMIT}.tar.gz -> i3ipcpp-${I3IPCPP_COMMIT}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="alsa curl doc i3wm ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'x11-base/xcb-proto[${PYTHON_MULTI_USEDEP}]')
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	doc? ( dev-python/sphinx )
	i3wm? (
		dev-libs/jsoncpp:=
		|| ( x11-wm/i3 x11-wm/i3-gaps )
	)
	mpd? ( media-libs/libmpdclient )
	network? ( net-wireless/wireless-tools )
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

src_prepare() {
	rmdir "${S}/lib/xpp" || die
	mv "${WORKDIR}/xpp-${XPP_COMMIT}" "${S}/lib/xpp" || die

	rmdir "${S}/lib/i3ipcpp" || die
	mv "${WORKDIR}/i3ipcpp-${I3IPCPP_COMMIT}" "${S}/lib/i3ipcpp" || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DBUILD_DOC="$(usex doc)"
		-DENABLE_I3="$(usex i3wm)"
		-DBUILD_IPC_MSG="$(usex ipc)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		# Bug 767949
		-DENABLE_CCACHE="OFF"
	)

	cmake_src_configure
}
