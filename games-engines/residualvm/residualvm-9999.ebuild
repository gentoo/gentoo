# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs xdg

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="http://www.residualvm.org/"
if [[ "${PV}" = 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/residualvm/residualvm.git"
else
	SRC_URI="http://www.residualvm.org/downloads/release/${PV}/${P}-sources.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="alsa debug jpeg mpeg2 mp3 opengl png truetype vorbis zlib"

# TODO: fix dynamic plugin support
# games crash without media-libs/libsdl2[alsa]
RDEPEND="
	media-libs/glew:0=
	media-libs/libsdl2[X,sound,alsa,joystick,opengl,video]
	virtual/glu
	alsa? ( media-libs/alsa-lib )
	jpeg? ( virtual/jpeg:0 )
	mp3? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0= )
	truetype? ( media-libs/freetype:2 )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	# not an autotools script
	# some configure options currently do nothing, verify on version bump !!!
	# disable explicitly, otherwise we get unneeded linkage (some copy-paste build system)
	local myconf=(
		--backend=sdl
		--disable-faad
		--disable-flac
		--disable-fluidsynth
		--disable-libunity
		--disable-sparkle
		--disable-tremor
		--docdir="/usr/share/doc/${PF}"
		--enable-all-engines
		--enable-verbose-build
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--host="${CHOST}"
		--prefix="${EPREFIX}/usr"
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable !debug release-mode)
		$(use_enable jpeg)
		$(use_enable mp3 mad)
		$(use_enable mpeg2)
		$(use_enable opengl)
		$(use_enable opengl opengl-shaders)
		$(use_enable png)
		$(use_enable truetype freetype2)
		$(use_enable vorbis)
		$(use_enable zlib)
	)
	./configure "${myconf[@]}" "${EXTRA_ECONF}" || die
}

src_compile() {
	emake AR="$(tc-getAR) cru" RANLIB=$(tc-getRANLIB)
}

src_install() {
	default
	doicon -s 256 icons/${PN}.png
}
