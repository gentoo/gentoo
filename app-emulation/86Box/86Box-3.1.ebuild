# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Emulator of x86-based machines based on PCem"
HOMEPAGE="https://github.com/86Box/86Box"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dinput experimental +fluidsynth +munt +dynarec new-dynarec +threads +usb vramdump"

DEPEND="
	media-libs/freetype:2=
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/openal
	media-libs/rtmidi
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
	fluidsynth? ( media-sound/fluidsynth )
	munt? ( media-libs/munt-mt32emu )
"

BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCPPTHREADS="$(usex threads)"
		-DDEV_BRANCH="$(usex experimental)"
		-DDINPUT="$(usex dinput)"
		-DDYNAREC="$(usex dynarec)"
		-DFLUIDSYNTH="$(usex fluidsynth)"
		-DMINITRACE="OFF"
		-DMUNT="$(usex munt)"
		-DNEW_DYNAREC="$(usex new-dynarec)"
		-DPREFER_STATIC="OFF"
		-DRELEASE="ON"
		-DUSB="$(usex usb)"
		-DVRAMDUMP="$(usex vramdump)"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "In order to use 86Box, you will need some roms for various emulated systems."
	elog "See https://github.com/86Box/roms for more information."
}
