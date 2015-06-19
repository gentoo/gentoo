# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-homer/fortune-mod-homer-0.1.ebuild,v 1.14 2015/02/04 21:51:34 tupone Exp $
EAPI=5
DESCRIPTION="Quotes from Homer Simpson"
HOMEPAGE="http://www.cs.indiana.edu/~crcarter/homer/homer.html"
SRC_URI="http://www.cs.indiana.edu/~crcarter/homer/homer-quotes.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/mod-/}

src_install() {
	insinto /usr/share/fortune
	doins homer homer.dat
}
