# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_LIB_NAME="PHPTAL"

DESCRIPTION="A templating engine for PHP5 that implements Zope Page Templates syntax"
HOMEPAGE="https://phptal.org/"
SRC_URI="https://github.com/${PN}/${PHP_LIB_NAME}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

S="${WORKDIR}/${PHP_LIB_NAME}-${PV}"

src_compile() { :; }

src_install() {
	insinto /usr/share/php/${PN}
	doins -r "classes/${PHP_LIB_NAME}"
	doins classes/PHPTAL.php tools/phptal_lint.php

	dodoc README.md
}

src_test() {
	[[ -z $(locale -a |grep en_GB) ]] && ewarn "Tests require en_GB locale to complete"
	phpunit || die
}
