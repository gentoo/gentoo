# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

MY_P="ChickensForLinux-Linux-${PV}"
DESCRIPTION="Target chickens with rockets and shotguns. Funny"
HOMEPAGE="http://www.chickensforlinux.com/"
SRC_URI="http://www.chickensforlinux.com/${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND="<media-libs/allegro-5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e "s:HighScores:${GAMES_STATEDIR}/${PN}/HighScores:" \
		-e "s:....\(.\)\(_\)\(.*.4x0\)\(.\):M\4\2\x42\x6Fn\1s\2:" \
		highscore.cpp HighScores \
		|| die "sed failed"
	sed -i \
		-e "s:options.cfg:${GAMES_SYSCONFDIR}/${PN}/options.cfg:" \
		-e "s:\"sound/:\"${GAMES_DATADIR}/${PN}/sound/:" \
		-e "s:\"dat/:\"${GAMES_DATADIR}/${PN}/dat/:" \
		main.cpp README \
		|| die "sed failed"
	sed -i \
		-e '/^CPPFLAGS/d' \
		-e 's:g++:\\$(CXX) \\$(CXXFLAGS) \\$(LDFLAGS):' \
		configure \
		|| die "sed failed"
}

src_configure() {
	bash ./configure || die "configure failed"
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r dat sound
	dodoc AUTHOR README
	insinto "${GAMES_STATEDIR}"/${PN}
	doins HighScores
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins options.cfg
	fperms g+w "${GAMES_STATEDIR}"/${PN}/HighScores
	make_desktop_entry ${PN} Chickens
	prepgamesdirs
}
