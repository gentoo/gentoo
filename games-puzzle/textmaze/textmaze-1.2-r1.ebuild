# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}_v${PV}
DESCRIPTION="An ncurses-based maze solving game written in Perl"
HOMEPAGE="http://robobunny.com/projects/textmaze/html/"
SRC_URI="http://www.robobunny.com/projects/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Curses"
DEPEND=""

S="${WORKDIR}/TextMaze"

src_prepare() {
	default
	sed -i \
		-e "s#/usr/local/bin/perl#/usr/bin/perl#" \
		textmaze || die
}

src_install() {
	dobin textmaze
	einstalldocs
}
