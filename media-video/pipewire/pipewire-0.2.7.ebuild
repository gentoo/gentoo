# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/PipeWire/pipewire.git"
	inherit git-r3
else
	SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.2"
IUSE="bluetooth doc ffmpeg libav gstreamer sdl systemd vaapi X"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
DEPEND="
	media-libs/alsa-lib
	sys-apps/dbus
	virtual/libudev
	bluetooth? ( media-libs/sbc )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	sdl? ( media-libs/libsdl2 )
	systemd? ( sys-apps/systemd )
	vaapi? ( x11-libs/libva )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	spa_use() {
		if ! use ${1}; then
			sed -e "/.*dependency.*'${2-$1}'/s/'${2-$1}'/'${2-$1}-disabled-by-USE-no-${1}'/" \
				-i spa/meson.build || die
		fi
	}

	default
	spa_use bluetooth sbc
	spa_use ffmpeg libavcodec
	spa_use ffmpeg libavformat
	spa_use ffmpeg libavfilter
	spa_use vaapi libva
	spa_use sdl sdl2
	spa_use X x11
}

src_configure() {
	local emesonargs=(
		-Dman=true
		$(meson_use doc docs)
		$(meson_feature gstreamer)
		$(meson_use systemd)
	)
	meson_src_configure
}

pkg_postinst() {
	elog "Package has optional sys-auth/rtkit RUNTIME support that may be"
	elog "disabled by setting DISABLE_RTKIT env var."
}
