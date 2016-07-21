# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A tool to parse smaps statistics"
HOMEPAGE="http://bmaurer.blogspot.de/2006/03/memory-usage-with-smaps.html"
SRC_URI="mirror://gentoo/smem.pl.${PV}.bz2
	https://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/smem.pl.${PV}.bz2"

IUSE=""

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-lang/perl
	dev-perl/Linux-Smaps"

src_compile() { :; }

src_install() {
	newbin smem.pl.${PV} smem || die
}
