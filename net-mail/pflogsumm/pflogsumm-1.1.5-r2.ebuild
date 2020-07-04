# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pflogsumm is a log analyzer for Postfix logs"
HOMEPAGE="https://jimsun.linxnet.com/postfix_contrib.html"
SRC_URI="https://jimsun.linxnet.com/downloads/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"

RDEPEND="dev-lang/perl
	dev-perl/Date-Calc"

DOCS=( ChangeLog pflogsumm-faq.txt README ToDo )
PATCHES=( "${FILESDIR}/${PN}-bdat.patch" ) # Bug 699976

src_install() {
	default
	doman pflogsumm.1
	dobin pflogsumm.pl
}
