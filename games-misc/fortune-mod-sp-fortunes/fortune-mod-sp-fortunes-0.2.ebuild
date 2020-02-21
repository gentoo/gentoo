# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_P=${P/fortune-mod-sp-fortunes/SP}
MY_PN=${PN/fortune-mod-sp-fortunes/SP}
DESCRIPTION="South Park Fortunes"
HOMEPAGE="http://eol.init1.nl/content/view/44/54/"
SRC_URI="http://eelco.is.a.rootboy.net/fortunecookies/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins SP SP.dat
}
