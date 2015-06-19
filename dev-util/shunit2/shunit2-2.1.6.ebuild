# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shunit2/shunit2-2.1.6.ebuild,v 1.2 2014/08/10 21:29:29 slyfox Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Unit-test framework for Bourne-based shell scripts"
HOMEPAGE="http://code.google.com/p/shunit2/wiki/ProjectInfo"
SRC_URI="http://shunit2.googlecode.com/files/${P}.tgz"

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
