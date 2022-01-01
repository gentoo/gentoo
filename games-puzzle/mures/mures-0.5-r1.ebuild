# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A clone of Sega's Chu Chu Rocket"
HOMEPAGE="http://mures.sourceforge.net/"
SRC_URI="mirror://sourceforge/mures/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-net
	media-libs/sdl-ttf
	opengl? ( virtual/opengl )"
RDEPEND="${DEPEND}"

dir="/usr/share/${PN}"

src_prepare() {
	default

	# Disable OpenGL support if USE flag is not set
	if ! use opengl ; then
		sed -i \
			-e 's: -DHAVE_GL::' \
			-e 's: -lGL::' \
			configure.in || die "sed failed"
	fi

	sed -i '$ s/\\//' \
		src/lua/Makefile.am \
		src/maps/battle/Makefile.am \
		|| die "sed failed"

	eapply "${FILESDIR}"/${P}-underlink.patch

	mv configure.{in,ac} || die
	eautoreconf

	cd src || die

	# Save to HOME
	eapply "${FILESDIR}"/${P}-save.patch

	# Modify game data & scrips path
	sed -i \
		-e "s:gui/:${dir}/gui/:" \
		-e "s:sounds/:${dir}/sounds/:" \
		gui.c || die "sed gui.c failed"
	sed -i \
		-e "s:images/:${dir}/images/:" \
		-e "s:textures/:${dir}/textures/:" \
		go_sdl.c || die "sed go_sdl.c failed"
	sed -i \
		-e "s:textures/:${dir}/textures/:" \
		go_gl.c || die "sed go_gl.c failed"
	sed -i \
		-e "s:input.lua:${dir}/input.lua:" \
		gi_sdl.c || die "sed gi_sdl.c failed"
	sed -i \
		-e "s:images/:${dir}/images/:" \
		anim.c output.c || die "sed anim.c output.c failed"
	sed -i \
		-e "s:maps/:${dir}/maps/:" \
		load_maps.lua || die "sed load_maps.lua failed"
	sed -i \
		-e "s:sounds/:${dir}/sounds/:" \
		audio_sdl.c || die "sed audio_sdl.c failed"
	sed -i \
		-e "s:load_maps.lua:${dir}/load_maps.lua:" \
		map.c || die "sed map.c failed"
}

src_install() {
	# Remove makefiles before installation
	rm -f src/*/Makefile* src/*/*/Makefile* || die "removing makefiles"

	dobin src/mures

	insinto "${dir}"
	doins -r src/{gui,images,sounds,textures,maps,*.lua}

	einstalldocs

	newicon src/images/cat_right.png ${PN}.png
	make_desktop_entry ${PN} "Mures"
}
