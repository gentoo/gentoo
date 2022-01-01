# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
# Source code and server part on Android device
SRC_URI="https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/${PN}/releases/download/v${PV}/${PN}-server-v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl2[X]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${PN}-server-v${PV}"
	)
	meson_src_configure
}
