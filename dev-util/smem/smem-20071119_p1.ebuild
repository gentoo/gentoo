# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/smem/smem-20071119_p1.ebuild,v 1.2 2015/02/11 04:30:33 bircoph Exp $

DESCRIPTION="A tool to parse smaps statistics"
HOMEPAGE="http://bmaurer.blogspot.de/2006/03/memory-usage-with-smaps.html"
SRC_URI="mirror://gentoo/smem.pl.${PV}.bz2
	http://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/smem.pl.${PV}.bz2"

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
