# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_PV="${PV/_/}"
MY_PV="${MY_PV/alpha/a}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="PHP parser for RDF and RSS documents"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

# Only needs PEAR_Exception (not in the tree), not all of PEAR.
# This can be made into an || dependency if we add PEAR_Exception.
RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR
	dev-php/PEAR-XML_Parser"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r XML
}
