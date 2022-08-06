# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Emulator of x86-based machines based on PCem"
HOMEPAGE="https://github.com/86Box/86Box"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dinput +dynarec experimental +fluidsynth +munt new-dynarec +openal +qt5 +threads"

DEPEND="
	app-emulation/faudio
	dev-libs/libevdev
	media-libs/freetype:2=
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/openal
	media-libs/rtmidi
	net-libs/libslirp
	sys-libs/zlib
	qt5? ( x11-libs/libXi )
"

RDEPEND="
	${DEPEND}
	fluidsynth? ( media-sound/fluidsynth )
	munt? ( media-libs/munt-mt32emu )
	openal? ( media-libs/openal )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qttranslations:5
		dev-qt/qtwidgets:5
	)
"

BDEPEND="virtual/pkgconfig"

src_configure() {
	# LTO needs to be filtered
	# See https://bugs.gentoo.org/854507
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DCPPTHREADS="$(usex threads)"
		-DDEV_BRANCH="$(usex experimental)"
		-DDINPUT="$(usex dinput)"
		-DDYNAREC="$(usex dynarec)"
		-DFLUIDSYNTH="$(usex fluidsynth)"
		-DMINITRACE="OFF"
		-DMUNT="$(usex munt)"
		-DNEW_DYNAREC="$(usex new-dynarec)"
		-DOPENAL="$(usex openal)"
		-DPREFER_STATIC="OFF"
		-DQT="$(usex qt5)"
		-DRELEASE="ON"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "In order to use 86Box, you will need some roms for various emulated systems."
	elog "See https://github.com/86Box/roms for more information."
}
