# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit php-pear-r1

DESCRIPTION="A full featured command line options and arguments parser"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=">=dev-php/pear-1.4"

RDEPEND="${DEPEND}"

src_install() {
	php-pear-r1_src_install
	rm -r "${D}"/usr/share/php/tests
	rm -r "${D}"/usr/share/php/docs
}
