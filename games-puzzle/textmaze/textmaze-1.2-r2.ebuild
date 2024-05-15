# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}_v${PV}"
DESCRIPTION="Ncurses-based maze solving game written in Perl"
HOMEPAGE="https://robobunny.com/projects/textmaze/html/"
SRC_URI="https://robobunny.com/projects/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/TextMaze"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/Curses"

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
