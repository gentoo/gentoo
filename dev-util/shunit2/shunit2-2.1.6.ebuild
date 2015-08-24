# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Unit-test framework for Bourne-based shell scripts"
HOMEPAGE="https://code.google.com/p/shunit2/wiki/ProjectInfo"
SRC_URI="https://shunit2.googlecode.com/files/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/perl
	net-misc/curl"

src_install() {
	dobin src/shunit2 || die

	# For backwards compat to <=2.1.5
	dosym /usr/bin/shunit2 /usr/share/shunit2/shunit2 || die

	dodoc -r examples || die
	dodoc doc/*.txt || die
	dohtml doc/*.{html,css} || die
}
