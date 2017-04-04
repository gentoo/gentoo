# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Provides the functionality to export PHP variables for visualization"
HOMEPAGE="https://github.com/sebastianbergmann/exporter"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/sebastianbergmann-recursion-context-2.0.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-lang/php:*
		dev-php/phpunit
		)"

S="${WORKDIR}/exporter-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:'${S}/src/':" "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/SebastianBergmann/Exporter"
	doins -r  src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
