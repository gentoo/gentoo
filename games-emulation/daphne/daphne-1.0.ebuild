# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="Laserdisc Arcade Game Emulator"
HOMEPAGE="http://www.daphne-emu.com/"
SRC_URI="http://www.daphne-emu.com/download/${P}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libogg
	media-libs/libvorbis
	sys-libs/zlib
	media-libs/libsdl[joystick,video]
	media-libs/sdl-mixer
	media-libs/libmpeg2
	virtual/opengl
	media-libs/glew"
RDEPEND=${DEPEND}

S=${WORKDIR}/v_1_0/src

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-vorbisfilefix.patch \
		"${FILESDIR}"/${P}-typefix.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-zlib.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-system-lmpeg2.patch

	sed -i "/m_appdir =/s:\.:${GAMES_DATADIR}/${PN}:" \
		io/homedir.cpp || die
	sed -i "s:pics/:${GAMES_DATADIR}/${PN}/&:" \
		video/video.cpp || die
	sed -i "s:sound/:${GAMES_DATADIR}/${PN}/&:" \
		sound/sound.cpp || die
	sed -i "s:./lib:$(games_get_libdir)/${PN}/lib:" \
		io/dll.h || die

	sed \
		-e "s:-DNATIVE_CPU_X86::" \
		-e "s:-DUSE_MMX::" \
		-e '/export USE_MMX = 1/s:^:# :' \
		Makefile.vars.linux_x86 >Makefile.vars || die
}

src_configure() {
	cd vldp2
	egamesconf --disable-accel-detect
}

src_compile() {
	local archflags

	if use x86; then
		archflags="-DNATIVE_CPU_X86 -DMMX_RGB2YUV -DUSE_MMX"
		export USE_MMX=1
	else
		# -fPIC is needed on amd64 but fails on x86.
		archflags="-fPIC"
	fi

	emake \
		CXX=$(tc-getCXX) \
		DFLAGS="${CXXFLAGS} ${archflags}"
	emake -C vldp2 \
		-f Makefile.linux \
		CC=$(tc-getCC) \
		DFLAGS="${CFLAGS} ${archflags}"
}

src_install() {
	cd ..
	newgamesbin daphne.bin daphne
	exeinto "$(games_get_libdir)"/${PN}
	doexe libvldp2.so
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r pics roms sound
	dodoc doc/*.{ini,txt}
	dohtml -r doc/*
	prepgamesdirs
}
