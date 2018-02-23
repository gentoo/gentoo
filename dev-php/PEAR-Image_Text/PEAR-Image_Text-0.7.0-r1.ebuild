# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Advanced text manipulations in images"
LICENSE="PHP-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-lang/php:*[gd,truetype]"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

src_test() {
	phpunit tests || die
}
