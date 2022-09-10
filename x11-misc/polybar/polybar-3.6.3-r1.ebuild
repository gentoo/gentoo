# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-single-r1

DESCRIPTION="A fast and easy-to-use tool for creating status bars"
HOMEPAGE="https://github.com/polybar/polybar"
SRC_URI="https://github.com/polybar/${PN}/releases/download/${PV}/${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="MIT"
SLOT="0"
IUSE="alsa curl doc i3wm ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'x11-base/xcb-proto[${PYTHON_USEDEP}]')
	dev-libs/libuv:=
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb:=[xkb]
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
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
	network? ( dev-libs/libnl:3 )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-prefix.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DBUILD_DOC="$(usex doc)"
		-DENABLE_I3="$(usex i3wm)"
		-DBUILD_POLYBAR_MSG="$(usex ipc)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		# Bug 767949
		-DENABLE_CCACHE="OFF"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc/"
	)

	cmake_src_configure
}
