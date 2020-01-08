# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Calendar to track menstruation cycles"
HOMEPAGE="http://www.kyberdigi.cz/projects/mencal/english.html"
SRC_URI="http://www.kyberdigi.cz/projects/mencal/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( README )

src_install() {
	dobin "${PN}"
	einstalldocs
}
