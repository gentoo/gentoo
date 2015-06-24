# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/pcalc/pcalc-1.2.ebuild,v 1.10 2015/06/24 13:39:08 vapier Exp $

inherit eutils

DESCRIPTION="the programmers calculator"
HOMEPAGE="https://github.com/vapier/pcalc"
SRC_URI="mirror://sourceforge/pcalc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog EXAMPLE README
}
