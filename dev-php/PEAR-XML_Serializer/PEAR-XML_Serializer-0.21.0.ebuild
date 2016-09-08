# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit php-pear-r1

DESCRIPTION="Swiss-army knife for reading and writing XML files"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

COMMON_DEPEND="dev-lang/php:*[xml]"

RDEPEND="${COMMON_DEPEND}
	>=dev-php/PEAR-XML_Parser-1.2.7
	>=dev-php/PEAR-XML_Util-1.1.1-r1
	"
DEPEND="${COMMON_DEPEND} test? ( ${RDEPEND} )"

src_test() {
	peardev run-tests -r || die
}
