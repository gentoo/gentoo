# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-2 php7-3 php7-4"
MY_PN="php-token-stream"

DESCRIPTION="Wrapper around PHP's tokenizer extension"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	|| (
		dev-lang/php:7.2[tokenizer(-)]
		dev-lang/php:7.3[tokenizer(-)]
		dev-lang/php:7.4[tokenizer(-)]
	)"
BDEPEND="test? ( ${RDEPEND} dev-php/phpunit )"
RESTRICT="!test? ( test )"

src_prepare() {
	sed -i -e 's/setUp()/setUp():void/' tests/Token/*.php || die
	default
}

src_install() {
	insinto /usr/share/php/PHP/Token
	doins -r src/*
	newins "${FILESDIR}/autoload-3.1.1.php" autoload.php
}

src_test() {
	mkdir vendor || die
	cp "${FILESDIR}/autoload-3.1.1.php" vendor/autoload.php || die
	sed -i 's~__DIR__~__DIR__."/../src"~' vendor/autoload.php || die
	for target in ${USE_PHP//-/.} ; do
		if [ -x /usr/bin/$target ] ; then
			${target} /usr/bin/phpunit -c phpunit.xml || die
		fi
	done
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/Token/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
