# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-at-linux/fortune-mod-at-linux-20030120.ebuild,v 1.14 2015/02/03 21:08:35 tupone Exp $
EAPI=5
MY_P="fortune-mod-at.linux-${PV}"
DESCRIPTION="Quotes from at.linux"
HOMEPAGE="http://fortune-mod-fvl.sourceforge.net/"
SRC_URI="mirror://sourceforge/fortune-mod-fvl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="unicode"

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}
	unicode? ( virtual/libiconv )"

S=${WORKDIR}/${MY_P}

src_compile() {
	# bug #322111
	if use unicode ; then
		iconv --from-code=ISO-8859-1 --to-code=UTF-8 at.linux > at.linux-utf8
		mv at.linux-utf8 at.linux
		strfile -s at.linux
	fi
}

src_install() {
	insinto /usr/share/fortune
	doins at.linux at.linux.dat
}
