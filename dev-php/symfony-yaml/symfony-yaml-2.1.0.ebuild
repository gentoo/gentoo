# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony YAML Component"
HOMEPAGE="https://github.com/symfony/yaml"
SRC_URI="https://github.com/symfony/yaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/yaml-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Yaml"
	doins -r . "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
