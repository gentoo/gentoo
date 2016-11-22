# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Like cowsay, but different because it involves robots and kittens"
HOMEPAGE="http://www.robotfindskitten.org/"
#SRC_URI="http://www.redhotlunix.com/${PN}.tar.gz"
SRC_URI="mirror://gentoo/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin kittensay rfksay robotsay
}
