# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/gav/gav-0.9.0.ebuild,v 1.6 2015/01/04 15:03:11 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="GPL Arcade Volleyball"
HOMEPAGE="http://gav.sourceforge.net/"
# the themes are behind a lame php-counter script.
SRC_URI="mirror://sourceforge/gav/${P}.tar.gz
	mirror://gentoo/fabeach.tgz
	mirror://gentoo/florindo.tgz
	mirror://gentoo/inverted.tgz
	mirror://gentoo/naive.tgz
	mirror://gentoo/unnamed.tgz
	mirror://gentoo/yisus.tgz
	mirror://gentoo/yisus2.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/sdl-image[jpeg,png]
	media-libs/sdl-net
	media-libs/libsdl[joystick,video]"
RDEPEND="${DEPEND}"

src_prepare() {
	local d

	epatch "${FILESDIR}"/${P}-ldflags.patch

	for d in . automa menu net ; do
		cp ${d}/Makefile.Linux ${d}/Makefile || die "cp ${d}/Makefile failed"
	done

	epatch "${FILESDIR}"/${P}-gcc43.patch
	sed -i \
		-e "s:/usr/bin:${GAMES_BINDIR}:" \
		Makefile \
		|| die "sed failed"
	sed -i \
		-e "/^CXXFLAGS=/s: -g : ${CXXFLAGS} :" CommonHeader \
		|| die "sed failed"

	# Now, move the additional themes in the proper directory
	mv ../{fabeach,florindo,inverted,naive,unnamed,yisus,yisus2} themes

	# no reason to have executable files in the themes
	find themes -type f -exec chmod a-x \{\} \;
}

src_compile() {
	# bug #41530 - doesn't like the hot parallel make action.
	emake -C automa
	emake -C menu
	emake -C net
	emake
}

src_install() {
	dodir "${GAMES_BINDIR}"
	emake ROOT="${D}" install
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r sounds
	dodoc CHANGELOG README
	prepgamesdirs
}
