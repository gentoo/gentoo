# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cgvg/cgvg-1.6.2.ebuild,v 1.4 2010/10/19 05:20:15 leio Exp $

DESCRIPTION="A tiny version of cscope that is much more useful in certian instances"
HOMEPAGE="http://uzix.org/cgvg.html"
SRC_URI="http://uzix.org/cgvg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README TODO
}
