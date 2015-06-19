# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/allegro/allegro-4.4.2-r1.ebuild,v 1.11 2015/06/04 17:49:34 mr_bones_ Exp $

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils eutils

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="http://alleg.sourceforge.net/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="Allegro MIT GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="alsa fbcon jack jpeg opengl oss png svga test vga vorbis X"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	svga? ( media-libs/svgalib )
	vorbis? ( media-libs/libvorbis )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
		opengl? (
			virtual/glu
			virtual/opengl
		)
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? (
		x11-proto/xextproto
		x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
		x11-proto/xproto
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-rpath.patch

	sed -i \
		-e "s:allegro-\${ALLEGRO_VERSION}:${PF}:" \
		docs/CMakeLists.txt || die
}

src_configure() {
	# WANT_LINUX_CONSOLE is by default OFF
	# WANT_EXAMPLES doesn't install anything

	mycmakeargs=(
		"-DDOCDIR=share/doc"
		"-DINFODIR=share/info"
		"-DMANDIR=share/man"
		$(cmake-utils_use_want alsa)
		"-DWANT_EXAMPLES=OFF"
		$(cmake-utils_use_want jack)
		$(cmake-utils_use_want jpeg JPGALLEG)
		"-DWANT_LINUX_CONSOLE=OFF"
		$(cmake-utils_use_want fbcon LINUX_FBCON)
		$(cmake-utils_use_want svga LINUX_SVGALIB)
		$(cmake-utils_use_want vga LINUX_VGA)
		$(cmake-utils_use_want png LOADPNG)
		$(cmake-utils_use_want vorbis LOGG)
		$(cmake-utils_use_want oss)
		$(cmake-utils_use_want test TESTS)
		$(cmake-utils_use_want X TOOLS)
		$(cmake-utils_use_want X X11)
		)

	if use X; then
		mycmakeargs+=(
			$(cmake-utils_use_want opengl ALLEGROGL)
			)
	else
		mycmakeargs+=(
			"-DWANT_ALLEGROGL=OFF"
			)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dohtml docs/html/*.html

	#176020 (init_dialog.3), #409305 (key.3)
	pushd docs/man >/dev/null
	local manpage
	for manpage in $(ls -d *.3); do
		newman ${manpage} ${PN}-${manpage}
	done
	popd >/dev/null

	if use X; then
		newbin setup/setup ${PN}-setup
		insinto /usr/share/${PN}
		doins {keyboard,language,setup/setup}.dat
		newicon misc/icon.png ${PN}.png
		make_desktop_entry ${PN}-setup "Allegro Setup" ${PN} "Settings"
	fi
}
