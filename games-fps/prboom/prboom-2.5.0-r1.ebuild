# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Port of ID's doom to SDL and OpenGL"
HOMEPAGE="http://prboom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[joystick,video]
	media-libs/sdl-mixer
	media-libs/sdl-net
	!<games-fps/lsdldoom-1.5
	virtual/opengl
	virtual/glu
"
DEPEND="${RDEPEND}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
To play the original Doom levels, place doom.wad and/or doom2.wad
into /usr/share/doom-data
Then run ${PN} accordingly.

doom1.wad is the shareware demo wad consisting of 1 episode,
and doom.wad is the full Doom 1 set of 3 episodes
(or 4 in the Ultimate Doom wad).

You can even emerge doom-data and/or freedoom to play for free.
"

src_prepare() {
	default

	ebegin "Detecting NVidia GL/prboom bug"
	$(tc-getCC) "${FILESDIR}"/${P}-nvidia-test.c 2> /dev/null
	local ret=$?
	eend ${ret} "NVidia GL/prboom bug found ;("
	[ ${ret} -eq 0 ] || eapply "${FILESDIR}"/${P}-nvidia.patch

	eapply "${FILESDIR}"/${P}-libpng14.patch

	sed -i \
		-e '/^gamesdir/ s/\/games/\/bin/' \
		src/Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's/: install-docDATA/:/' \
		-e '/^SUBDIRS/ s/doc//' \
		Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's:-ffast-math $CFLAGS_OPT::' \
		configure \
		|| die "sed configure failed"
}

src_configure() {
	# leave --disable-cpu-opt in otherwise the configure script
	# will append -march=i686 and crap ... let the user's CFLAGS
	# handle this ...
	econf \
		--enable-gl \
		--disable-i386-asm \
		--disable-cpu-opt \
		--with-waddir="/usr/share/doom-data"
}

src_install() {
	default

	doman doc/*.{5,6}

	dodoc doc/README.* doc/*.txt
	readme.gentoo_create_doc

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "PrBoom"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
