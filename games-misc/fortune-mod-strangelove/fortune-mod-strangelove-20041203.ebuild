# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-strangelove/fortune-mod-strangelove-20041203.ebuild,v 1.10 2015/02/05 17:40:52 tupone Exp $
EAPI=5
DESCRIPTION="Quotes from Dr. Strangelove"
HOMEPAGE="http://seiler.us/wiki/index.php/Strangelove"
SRC_URI="http://seiler.us/wiki/images/4/48/Strangelove_${PV}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/fortune-mod-/}

src_install() {
	insinto /usr/share/fortune
	doins strangelove strangelove.dat
}
