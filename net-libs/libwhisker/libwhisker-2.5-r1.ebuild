# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libwhisker/libwhisker-2.5-r1.ebuild,v 1.1 2014/11/09 22:12:31 dilfridge Exp $

EAPI=5

inherit perl-module
MY_P=${PN}2-${PV}

DESCRIPTION="Perl module geared to HTTP testing"
HOMEPAGE="http://www.wiretrip.net/rfp/lw.asp"
SRC_URI="http://www.wiretrip.net/rfp/libwhisker/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ssl"

DEPEND=""
RDEPEND="virtual/perl-MIME-Base64
	ssl? ( dev-perl/Net-SSLeay )"

S=${WORKDIR}/${MY_P}

src_compile() {
	perl Makefile.pl lib || die
}

src_install() {
	perl_set_version
	insinto "${VENDOR_LIB}"
	doins LW2.pm
	dodoc CHANGES KNOWNBUGS README
}
