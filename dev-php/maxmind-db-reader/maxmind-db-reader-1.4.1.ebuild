# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="MaxMind-DB-Reader-php"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"
PHP_EXT_S="${S}/ext"
PHP_EXT_NAME="maxminddb"
PHP_EXT_OPTIONAL_USE="extension"

USE_PHP="php5-6 php7-1 php7-2 php7-3"

inherit php-ext-source-r3

DESCRIPTION="PHP reader for the MaxMind database format"
HOMEPAGE="https://github.com/maxmind/${MY_PN}"
SRC_URI="https://github.com/maxmind/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="extension test"
RESTRICT="!test? ( test )"

DEPEND="extension? ( dev-libs/libmaxminddb )"
RDEPEND="${DEPEND}"

src_prepare(){
	# We need to call eapply_user ourselves, because it may be skipped
	# if either the "extension" USE flag is not set, or if the user's
	# PHP_TARGETS is essentially empty. In the latter case, the eclass
	# src_prepare does nothing. We only call the eclass phase conditionally
	# because the correct version of e.g. "phpize" may not be there
	# unless USE=extension is set.
	if use extension ; then
		php-ext-source-r3_src_prepare
	else
		default
	fi
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

src_install() {
	dodoc CHANGELOG.md README.md
	insinto /usr/share/php
	doins -r src/MaxMind
	insinto /usr/share/php/MaxMind/Db
	doins autoload.php

	use extension && php-ext-source-r3_src_install
}

src_test() {
	# The PHP API has its own set of tests that isn't shipped with the
	# release tarballs at the moment (github issues 55).
	use extension && php-ext-source-r3_src_test
}

pkg_postinst(){
	elog "${PN} has been installed in /usr/share/php/MaxMind/Db/."
	elog "To use it in a script, require('MaxMind/Db/autoload.php'),"
	elog "and then most of the examples in the documentation should"
	elog "work without further modification."
}
