# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib games

DESCRIPTION="An X11 clone of the well-known Scrabble"
HOMEPAGE="http://freshmeat.net/projects/xscrabble/?topic_id=80"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/educational_games/${P}.tgz
	linguas_fr? ( ftp://ftp.ac-grenoble.fr/ge/educational_games/xscrabble_fr.tgz )
	ftp://ftp.ac-grenoble.fr/ge/educational_games/xscrabble_en.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="linguas_fr"

RDEPEND="x11-libs/libXaw
	x11-libs/libXp"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

src_unpack() {
	unpack ${P}.tgz
	cp "${DISTDIR}"/xscrabble_en.tgz .
	use linguas_fr && cp "${DISTDIR}"/xscrabble_fr.tgz .
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-path-fixes.patch \
		"${FILESDIR}"/${P}-build.patch
	sed -i '/install/s/-s //' build || die "sed failed"
}

src_compile() {
	./build bin || die "build failed"
}

src_install() {
	local f
	export DESTDIR="${D}" LIBDIR="$(get_libdir)"
	./build install || die "install failed"
	if use linguas_fr ; then
		./build lang fr || die "fr failed"
	fi
	./build lang en || die "en failed"
	for f in "${D}"/usr/"${LIBDIR}"/X11/app-defaults/* ; do
		[[ -L ${f} ]] && continue
		sed -i \
			-e "s:/usr/games/lib/scrabble/:${GAMES_DATADIR}/${PN}/:" \
			-e "s:fr/eng:fr/en:" \
			${f} || die "sed ${f} failed"
	done
	dodoc CHANGES README
	prepgamesdirs
}
