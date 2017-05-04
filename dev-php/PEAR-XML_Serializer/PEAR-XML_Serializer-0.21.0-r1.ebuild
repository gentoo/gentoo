# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit php-pear-r2

DESCRIPTION="Swiss-army knife for reading and writing XML files"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="examples test"

RDEPEND="dev-lang/php:*[xml]
	>=dev-php/PEAR-XML_Parser-1.2.7
	>=dev-php/PEAR-XML_Util-1.1.1-r1
	"
DEPEND="test? ( ${RDEPEND} )"

src_install() {
	php-pear-r2_src_install
	if use examples ; then
		insinto /usr/share/php/docs/${PN/PEAR-//}
		doins -r examples
	fi
}

src_test() {
	peardev run-tests -r || die
}
