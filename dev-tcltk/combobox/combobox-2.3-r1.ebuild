# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/combobox/combobox-2.3-r1.ebuild,v 1.3 2015/03/25 13:56:09 ago Exp $

EAPI=5

inherit multilib

DESCRIPTION="A combobox megawidget"
HOMEPAGE="http://www1.clearlight.com/~oakley/tcl/combobox/index.html"
SRC_URI="http://www1.clearlight.com/~oakley/tcl/combobox/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/tcl:0="
DEPEND=""

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins *tcl *tmml *n
	dodoc *txt
	dohtml *html
}
