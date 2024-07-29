# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Atari 800 emulator"
HOMEPAGE="https://atari800.github.io/"
SRC_URI="
	https://github.com/atari800/atari800/releases/download/ATARI800_${PV//./_}/${P}-src.tgz
	https://sourceforge.net/projects/${PN}/files/ROM/Original%20XL%20ROM/xf25.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="encode-mp3 opengl readline +sdl +sound"
REQUIRED_USE="
	encode-mp3? ( sound )
	opengl? ( sdl )
"

DEPEND="
	encode-mp3? (
		media-sound/lame
	)
	sdl? (
		>=media-libs/libsdl-1.2.0[joystick,opengl?,sound?,video]
	)
	!sdl? (
		sys-libs/ncurses:=
	)
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
	media-libs/libpng:=
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/unzip
"

src_prepare() {
	local PATCHES=(
		# Bug 544608
		"${FILESDIR}"/atari800-3.1.0-tgetent-detection.patch
	)

	default
	eautoreconf
}

src_configure() {
	local video=ncurses
	local sound=no

	if use sdl; then
		video=sdl
		use sound && sound=sdl
	elif use sound; then
		sound=oss
	fi

	local myconf=(
		$(use_with opengl)
		$(use_with readline)
		$(use_with encode-mp3 mp3)
		--with-video=${video}
		--with-sound=${sound}
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	insinto "/usr/share/${PN}"
	doins "${WORKDIR}/"*.ROM
	insinto /etc
	newins "${FILESDIR}"/atari800-4.2.0.cfg atari800.cfg
	newicon data/atari2.svg ${PN}.svg
	make_desktop_entry ${PN} "Atari 800 emulator"
}
