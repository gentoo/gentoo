# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/mecab-perl/mecab-perl-0.996.ebuild,v 1.4 2015/05/15 06:58:46 pacho Exp $

EAPI="5"

inherit perl-module

DESCRIPTION="Perl binding for MeCab"
HOMEPAGE="http://mecab.sourceforge.net/"
SRC_URI="http://mecab.googlecode.com/files/${P}.tar.gz"

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
