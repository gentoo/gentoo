# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A console perl script for sending SMS to cell phones"
HOMEPAGE="http://linuxsms.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ppc s390 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1"
DEPEND=""

src_compile() { :; }

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc BUGS CHANGES README README.ES TODO
}
