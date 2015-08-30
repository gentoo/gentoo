# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Command-line trash can emulation"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://www.iq-computing.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

RDEPEND=">=dev-lang/perl-5"

src_install() {
	newbin perltrash.pl perltrash || die
	dodoc README.txt
}
