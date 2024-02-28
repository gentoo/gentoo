# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
# Source code and server part on Android device
SRC_URI="
	https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/${PN}/releases/download/v${PV}/${PN}-server-v${PV}
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	media-libs/libsdl2[X]
	media-video/ffmpeg:=
	virtual/libusb:1
"
# Manual install for ppc64 until bug #723528 is fixed
RDEPEND="
	${DEPEND}
	!ppc64? ( dev-util/android-tools )
"

src_configure() {
	local emesonargs=(
		-Dprebuilt_server="${DISTDIR}/${PN}-server-v${PV}"
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postrm

	einfo "If you use pipewire because of a problem with libsdl2 it is possible that"
	einfo "scrcpy will not start, in which case start the program by exporting the"
	einfo "environment variable SDL_AUDIODRIVER=pipewire."
	einfo "For more information see https://github.com/Genymobile/scrcpy/issues/3864."
}
