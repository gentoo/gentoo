# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A somewhat comprehensive collection of Dutch Linux man pages"
HOMEPAGE="http://doc.nl.linux.org/MANPAGE/"
SRC_URI="ftp://ftp.nl.linux.org/pub/DOC-NL/manpages-nl/manpages-nl-${PV}.tar.gz"

LICENSE="man-pages GPL-2+ GPL-2 BSD LDP-1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/manpages-nl-${PV}
