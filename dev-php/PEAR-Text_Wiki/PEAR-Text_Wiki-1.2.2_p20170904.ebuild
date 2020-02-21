# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 vcs-snapshot

DESCRIPTION="Abstracts parsing and rendering rules for Wiki markup in structured plain text"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
# Pull from github as pear.php.net is not updated
SRC_URI="https://github.com/pear/${PHP_PEAR_PKG_NAME}/archive/32fd5f483f34645f4efd96d385d8950ea26d4a2a.tar.gz -> ${PEAR_P}.tar.gz"

DEPEND="test? ( dev-php/phpunit dev-php/PEAR-PEAR )"

src_test() {
	peardev run-tests tests || die
	phpunit tests/*.php || die
}

src_install() {
	php-pear-r2_src_install
	insinto /usr/share/php/.packagexml
	newins package.xml "${PEAR_P}.xml"
}
