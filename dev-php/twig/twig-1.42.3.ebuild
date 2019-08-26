# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Twig"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="PHP templating engine with syntax similar to Django"
HOMEPAGE="http://twig.sensiolabs.org/"
SRC_URI="https://github.com/twigphp/${MY_PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-lang/php:*[ctype] dev-php/fedora-autoloader"
DEPEND="test? ( dev-php/phpunit ${RDEPEND} )"
# Test fail due to missing Symphony dependencies
RESTRICT="test"

src_install(){
	# The autoloader requires the 'T' in "Twig" capitalized.
	insinto "/usr/share/php/${MY_PN}/lib"
	doins -r lib/"${MY_PN}"/*
	insinto "/usr/share/php/${MY_PN}/src"
	doins -r src/*
	insinto "/usr/share/php/${MY_PN}"
	doins "${FILESDIR}/Autoloader.php"

	dodoc README.rst CHANGELOG

	# This installs the reStructuredText source documents. There's got
	# to be some way to turn them into HTML using Sphinx, but upstream
	# doesn't provide for it.
	use doc && dodoc -r doc
}

src_test(){
	cp "${FILESDIR}/Autoloader.php" "${S}" || die
	phpunit --bootstrap Autoloader.php || die "test suite failed"
	rm "${S}/Autoloader.php" || die
}

pkg_postinst(){
	elog "${PN} has been installed in /usr/share/php/${MY_PN}/."
	elog "To use it in a script, require('${MY_PN}/Autoloader.php')"
}
