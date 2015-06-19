# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-sp-fortunes/fortune-mod-sp-fortunes-0.2.ebuild,v 1.7 2015/03/29 16:35:29 mr_bones_ Exp $

EAPI=5
MY_P=${P/fortune-mod-sp-fortunes/SP}
MY_PN=${PN/fortune-mod-sp-fortunes/SP}
DESCRIPTION="South Park Fortunes"
HOMEPAGE="http://eol.init1.nl/content/view/44/54/"
SRC_URI="http://eelco.is.a.rootboy.net/fortunecookies/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins SP SP.dat
}
