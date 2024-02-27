# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bleeding edge Icinga Web 2 libraries"
HOMEPAGE="https://github.com/Icinga/icingaweb2-module-incubator/"
SRC_URI="https://codeload.github.com/Icinga/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="php_targets_php8-1 php_targets_php8-2"

PHP_DEPEND="
	php_targets_php8-1? ( dev-lang/php:8.1[curl] )
	php_targets_php8-2? ( dev-lang/php:8.2[curl] )
"
RDEPEND="
	${PHP_DEPEND}
	>=www-apps/icingaweb2-2.9.0
	>=dev-libs/icinga-php-thirdparty-0.8.0
	>=dev-libs/icinga-php-library-0.5.0
"

src_install() {
	insinto /usr/share/icingaweb2/modules/${PN##*-}/
	doins -r .
}
