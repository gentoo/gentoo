# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/durep/durep-0.9-r4.ebuild,v 1.5 2014/08/10 01:37:42 patrick Exp $

EAPI=4
inherit eutils

DESCRIPTION="A perl script designed for monitoring disk usage in a more visual way than du"
HOMEPAGE="http://gentoo.org"
SRC_URI="http://www.hibernaculum.net/download/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/MLDBM
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gigabyte.patch \
		"${FILESDIR}"/${PF}-color-output.patch \
		"${FILESDIR}"/${P}-dirhandle.patch
}

src_install() {
	dobin durep
	doman durep.1
	dodoc BUGS CHANGES README THANKS
	dohtml -A cgi *.cgi *.css *.png
}
