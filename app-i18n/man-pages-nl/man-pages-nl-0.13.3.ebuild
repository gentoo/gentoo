# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A somewhat comprehensive collection of Dutch Linux man pages"
HOMEPAGE="http://doc.nl.linux.org/MANPAGE/"
SRC_URI="ftp://ftp.nl.linux.org/pub/DOC-NL/manpages-nl/manpages-nl-${PV}.tar.gz"

LICENSE="man-pages GPL-2+ GPL-2 BSD LDP-1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/manpages-nl-${PV}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
