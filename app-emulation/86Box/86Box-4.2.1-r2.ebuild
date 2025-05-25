# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Emulator of x86-based machines based on PCem"
HOMEPAGE="https://github.com/86Box/86Box"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="experimental +fluidsynth +munt new-dynarec +openal +qt6 +threads vde"

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
	fluidsynth? ( media-sound/fluidsynth:= )
	munt? ( media-libs/munt-mt32emu )
	openal? ( media-libs/openal )
	qt6? (
		dev-libs/wayland
		dev-qt/qtbase:6=[gui,network,opengl,widgets]
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libxkbcommon
	)
"
RDEPEND="${DEPEND}
	qt6? ( dev-qt/qttranslations:6 )
	vde? ( net-misc/vde )
"
BDEPEND="
	virtual/pkgconfig
	qt6? ( kde-frameworks/extra-cmake-modules )
"

PATCHES=( "${FILESDIR}"/${P}-crashfix-{1,2,3}.patch ) # bug #953992, git master

src_configure() {
	# LTO needs to be filtered
	# See https://bugs.gentoo.org/854507
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DCPPTHREADS="$(usex threads)"
		-DDEV_BRANCH="$(usex experimental)"
		-DDYNAREC="ON"
		-DMUNT_EXTERNAL="$(usex munt)"
		-DFLUIDSYNTH="$(usex fluidsynth)"
		-DMINITRACE="OFF"
		-DMUNT="$(usex munt)"
		-DNEW_DYNAREC="$(usex new-dynarec)"
		-DOPENAL="$(usex openal)"
		-DPREFER_STATIC="OFF"
		-DRTMIDI="ON"
		-DQT="$(usex qt6)"
		-DRELEASE="ON"
		$(usex qt6 '-DUSE_QT6=ON' '')
		-DHAS_VDE="$(usex vde "${EPREFIX}/usr/$(get_libdir)/libvdeplug.so" "HAS_VDE-NOTFOUND")"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "In order to use 86Box, you will need some roms for various emulated systems."
	elog "See https://github.com/86Box/roms for more information."
}
