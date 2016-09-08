# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit php-pear-r1

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
DESCRIPTION="Fast and safe little cache system"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/pear-1.10.1"
RDEPEND="${DEPEND}"

src_test() {
	peardev run-tests -r || die
}

src_install() {
	php-pear-r1_src_install
	find "${D}" -name LICENSE -delete || die
}
