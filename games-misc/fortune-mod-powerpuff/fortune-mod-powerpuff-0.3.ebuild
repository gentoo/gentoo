# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MY_PN=powerpuff
DESCRIPTION="Quotes taken from the Power Puff Girls series from Cartoon Network"
HOMEPAGE="http://eol.init1.nl/content/view/43/54/"
SRC_URI="http://eelco.is.a.rootboy.net/fortunecookies/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	insinto /usr/share/fortune
	doins powerpuff powerpuff.dat
}
