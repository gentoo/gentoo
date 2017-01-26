# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Perl binding for MeCab"
# HOMEPAGE="http://mecab.sourceforge.net/" dead project, no homepage found anymore
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE=""

DEPEND="~app-text/mecab-${PV}"
RDEPEND="${DEPEND}"

src_install() {
	perl-module_src_install
	dohtml bindings.html
	dodoc test.pl
}
