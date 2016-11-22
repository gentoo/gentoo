# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Calendar to track menstruation cycles"
HOMEPAGE="http://www.kyberdigi.cz/projects/mencal/english.html"
SRC_URI="http://www.kyberdigi.cz/projects/mencal/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~mips ~alpha ~hppa ~ia64 ~ppc64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${PN}"
	dodoc README
}
