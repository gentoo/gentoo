# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="+curl +fileinfo +ssl test +zlib"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*[curl?,fileinfo?,ssl?,zlib?]
>=dev-php/PEAR-Net_URL2-2.2.0"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

src_prepare() {
	sed -i "s~@data_dir@~${EPREFIX}/usr/share/php/data~" HTTP/Request2/CookieJar.php || die
	default
}

src_test() {
	phpunit tests || die
}

src_install() {
	php-pear-r2_src_install
	insinto "/usr/share/php/data/${PHP_PEAR_PKG_NAME}"
	doins data/*
}
