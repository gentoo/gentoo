# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/style-check/style-check-0.14.ebuild,v 1.3 2012/03/09 10:58:53 phajdan.jr Exp $

EAPI=4

DESCRIPTION="Parses latex-formatted text in search of forbidden phrases"
HOMEPAGE="http://www.cs.umd.edu/~nspring/software/style-check-readme.html"
SRC_URI="http://www.cs.umd.edu/~nspring/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND="dev-lang/ruby"
DEPEND="test? ( dev-lang/ruby )"

src_install() {
	dodir /etc/style-check.d
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install
	dohtml README.html
}
