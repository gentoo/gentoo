# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A somewhat comprehensive collection of Romanian Linux man pages"
HOMEPAGE="http://www.rolix.org/man/arhiva/"
SRC_URI="http://www.rolix.org/man/arhiva/${P}.tar.gz"

LICENSE="LDP-1 GPL-2+ man-pages"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/man-ro

src_compile() { :; }

src_install() {
	insinto /usr/share/man/ro/man1
	doins man1/*.1 || die "doins"
}
