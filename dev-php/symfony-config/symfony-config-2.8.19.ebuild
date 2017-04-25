# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Config Component"
HOMEPAGE="https://github.com/symfony/config"
SRC_URI="https://github.com/symfony/config/archive/v${PV}.tar.gz -> symfony-config-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# This needs a newer phpunit and a modified autoload.php but should work.
RESTRICT=test

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/symfony-filesystem"
DEPEND="test? (	${RDEPEND} dev-php/phpunit )"

S="${WORKDIR}/config-${PV}"

src_prepare() {
	default
	if use test; then
		# Not quite right: we need to include PHPUnit's autoload.php as
		# part of ours for the test suite to work.
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Config"
	doins -r . "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
