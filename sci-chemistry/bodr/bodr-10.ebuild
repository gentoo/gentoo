# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The Blue Obelisk Data Repository listing element and isotope properties"
HOMEPAGE="http://sourceforge.net/projects/bodr"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"
IUSE=""

DEPEND="dev-libs/libxslt"
RDEPEND=""

DOCS=( "THANKS" "AUTHORS" "README" "ChangeLog" )

src_prepare(){
	sed -i -e "s/COPYING//g" Makefile.* || die
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}
}
