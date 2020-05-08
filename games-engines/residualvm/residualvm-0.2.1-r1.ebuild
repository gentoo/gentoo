# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs gnome2-utils

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="https://www.residualvm.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: fix dynamic plugin support
# games crash without media-libs/libsdl[alsa]
RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/libsdl[X,sound,alsa,joystick,opengl,video]
	sys-libs/zlib
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

src_configure() {
	# not an autotools script
	# most configure options currently do nothing, verify on version bump !!!
	# disable explicitly, otherwise we get unneeded linkage (some copy-paste build system)
	./configure \
		--backend=sdl \
		--disable-debug \
		--disable-faad \
		--disable-flac \
		--disable-fluidsynth \
		--disable-libunity \
		--disable-mad \
		--disable-sparkle \
		--disable-translation \
		--disable-tremor \
		--disable-vorbis \
		--docdir="/usr/share/doc/${PF}" \
		--enable-all-engines \
		--enable-release-mode \
		--enable-zlib \
		|| die "configure failed"
}

src_compile() {
	emake \
		VERBOSE_BUILD=1 \
		AR="$(tc-getAR) cru" \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	dobin residualvm

	insinto "/usr/share/${PN}"
	doins gui/themes/modern.zip dists/engine-data/residualvm-grim-patch.lab

	doicon -s scalable icons/${PN}.svg
	doicon -s 256 icons/${PN}.png
	domenu dists/${PN}.desktop

	doman dists/${PN}.6
	dodoc AUTHORS README.md KNOWN_BUGS TODO
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
