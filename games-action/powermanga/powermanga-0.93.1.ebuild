# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools games

DESCRIPTION="An arcade 2D shoot-em-up game"
HOMEPAGE="http://linux.tlk.fr/"
SRC_URI="http://linux.tlk.fr/games/Powermanga/download/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2[sound,joystick,video]
	media-libs/libpng:0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86dga
	media-libs/sdl-mixer[mod]"
DEPEND=${RDEPEND}

src_prepare() {
	local f
	for f in src/assembler.S src/assembler_opt.S ; do
		einfo "patching $f"
		cat <<-EOF >> ${f}
		#if defined(__linux__) && defined(__ELF__)
		.section .note.GNU-stack,"",%progbits
		#endif
		EOF
	done
	epatch "${FILESDIR}"/${P}-flags.patch
	sed -i \
		-e "/scoredir/s#/var/games/powermanga#${GAMES_STATEDIR}#" \
		src/Makefile.am || die
	eautoreconf
}

src_configure() {
	egamesconf --prefix=/usr
}

src_install() {
	newgamesbin src/powermanga powermanga.bin
	doman powermanga.6
	dodoc AUTHORS CHANGES README

	insinto "${GAMES_DATADIR}/powermanga"
	doins -r data sounds graphics texts

	find "${D}${GAMES_DATADIR}/powermanga/" -name "Makefil*" -execdir rm -f \{\} +

	insinto "${GAMES_STATEDIR}"
	local f
	for f in powermanga.hi-easy powermanga.hi powermanga.hi-hard ; do
		touch "${D}${GAMES_STATEDIR}/${f}" || die
		fperms 660 "${GAMES_STATEDIR}/${f}"
	done

	games_make_wrapper powermanga powermanga.bin "${GAMES_DATADIR}/powermanga"
	make_desktop_entry powermanga Powermanga
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "NOTE: The highscore file format has changed."
	ewarn "Older highscores will not be retained."
}
