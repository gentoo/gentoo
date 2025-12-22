# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic xdg-utils

DESCRIPTION="Emulator of x86-based machines based on PCem"
HOMEPAGE="https://github.com/86Box/86Box"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="discord experimental +fluidsynth +munt new-dynarec +openal +qt6 +threads vde vnc"

DEPEND="
	app-emulation/faudio
	dev-libs/libevdev
	dev-libs/libserialport
	media-libs/freetype:2=
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/libsndfile
	media-libs/openal
	media-libs/rtmidi
	net-libs/libslirp
	virtual/zlib:=
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
	vnc? ( net-libs/libvncserver )
"
RDEPEND="${DEPEND}
	qt6? ( dev-qt/qttranslations:6 )
	vde? ( net-misc/vde )
"
BDEPEND="
	virtual/pkgconfig
	qt6? ( kde-frameworks/extra-cmake-modules )
"

PATCHES=( "${FILESDIR}/${PN}-5.3-fallthrough-define-available-in-C-code.patch" )

src_configure() {
	# LTO needs to be filtered
	# See https://bugs.gentoo.org/854507
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DCPPTHREADS="$(usex threads)"
		-DDEV_BRANCH="$(usex experimental)"
		-DDISCORD="$(usex discord)"
		-DDYNAREC="ON"
		-DFLUIDSYNTH="$(usex fluidsynth)"
		-DHAS_VDE="$(usex vde "${EPREFIX}/usr/$(get_libdir)/libvdeplug.so" "HAS_VDE-NOTFOUND")"
		-DMINITRACE="OFF"
		-DMUNT="$(usex munt)"
		-DMUNT_EXTERNAL="$(usex munt)"
		-DNEW_DYNAREC="$(usex new-dynarec)"
		-DOPENAL="$(usex openal)"
		-DPREFER_STATIC="OFF"
		-DQT="$(usex qt6)"
		-DRELEASE="ON"
		-DRTMIDI="ON"
		$(usex qt6 '-DUSE_QT6=ON' '')
		-DVNC="$(usex vnc)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	domenu src/unix/assets/net.86box.86Box.desktop
	for iconsize in 48 64 72 96 128 192 256 512; do
		doicon -s $iconsize src/unix/assets/${iconsize}x${iconsize}/net.86box.86Box.png
	done
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "In order to use 86Box, you will need some roms for various emulated systems."
	elog "See https://github.com/86Box/roms for more information."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
