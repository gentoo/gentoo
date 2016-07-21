# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="GNU make replacement"
HOMEPAGE="http://makepp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc alpha"
IUSE=""
DEPEND=">=dev-lang/perl-5.6.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-install.patch
	# There is a sandbox violation in this test.
	# In future versions, this ebuild should try to find
	# a better way of avoiding this, but the current version
	# appears to have garbage NUL characters all over the test files,
	# making them complicated to edit.
	# Robert Coie <rac@gentoo.org> 2002.02.18
	rm "${S}"/makepp_tests/include.test
}

src_compile() {
	make test || die
}

src_install() {
	perl install.pl /usr "${D}" /usr/bin /usr/share/makepp /usr/share/doc/makepp
}
