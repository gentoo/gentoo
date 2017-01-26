# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="Twig"
USE_PHP="php5-6"
S="${WORKDIR}/${MY_PN}-${PV}"
PHP_EXT_S="${S}/ext/${PN}"
PHP_EXT_NAME="${PN}"
PHP_EXT_OPTIONAL_USE="extension"

inherit php-ext-source-r3

DESCRIPTION="PHP templating engine with syntax similar to Django"
HOMEPAGE="http://twig.sensiolabs.org/"
SRC_URI="https://github.com/twigphp/${MY_PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc extension test"

DEPEND="test? ( dev-php/phpunit )"

# We always require *some* version of PHP; the eclass (conditionally)
# requires *specific* versions.
RDEPEND="dev-lang/php"

src_unpack() {
	# Don't make copies of the source tree if they won't be used.
	if use extension; then
		php-ext-source-r3_src_unpack
	else
		default
	fi
}

src_prepare(){
	# We need to call eapply_user ourselves, because it may be skipped
	# if either the "extension" USE flag is not set, or if the user's
	# PHP_TARGETS is essentially empty (does not contain "php5-6"). In
	# the latter case, the eclass src_prepare does nothing. We only call
	# the eclass phase conditionally because the correct version of
	# e.g. "phpize" may not be there unless USE=extension is set.
	eapply_user
	use extension && php-ext-source-r3_src_prepare
}

src_configure() {
	# The eclass phase will try to run the ./configure script even if it
	# doesn't exist (in contrast to the default src_configure), so we
	# need to skip it if the eclass src_prepare (that creates said
	# script) is not run.
	use extension && php-ext-source-r3_src_configure
}

src_compile() {
	# Avoids the same problem as in src_configure.
	use extension && php-ext-source-r3_src_compile
}

src_install(){
	use extension && php-ext-source-r3_src_install

	cd "${S}" || die
	# The autoloader requires the 'T' in "Twig" capitalized.
	insinto "/usr/share/php/${MY_PN}"
	doins -r lib/"${MY_PN}"/*

	# The eclass src_install calls einstalldocs, so we may install a few
	# files twice. Doing so should be harmless.
	dodoc README.rst CHANGELOG

	# This installs the reStructuredText source documents. There's got
	# to be some way to turn them into HTML using Sphinx, but upstream
	# doesn't provide for it.
	use doc && dodoc -r doc
}

src_test(){
	phpunit --bootstrap test/bootstrap.php || die "test suite failed"
}

pkg_postinst(){
	elog "${PN} has been installed in /usr/share/php/${MY_PN}/."
	elog "To use it in a script, require('${MY_PN}/Autoloader.php'),"
	elog "and then run \"Twig_Autoloader::register();\". Most of"
	elog "the examples in the documentation should work without"
	elog "further modification."
}
