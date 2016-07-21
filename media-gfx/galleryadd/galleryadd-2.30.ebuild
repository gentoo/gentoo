# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Perl script to recursively adds directories/images to Gallery"
HOMEPAGE="http://iainlea.dyndns.org/software/galleryadd/"
SRC_URI="http://iainlea.dyndns.org/software/galleryadd/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND="dev-perl/libwww-perl
		 virtual/perl-Time-HiRes"
DEPEND=""

S="${WORKDIR}"

src_install() {
	dobin galleryadd.pl
}
