# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A template engine for PHP"
HOMEPAGE="https://www.smarty.net/ https://github.com/smarty-php/smarty/"
SRC_URI="https://github.com/smarty-php/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="doc examples"

# PHP unicode support is detected at runtime, and the cached templates
# that smarty generates depend on it. If, later on, PHP is reinstalled
# without unicode support, all of the previously-generated cached
# templates will begin to throw 500 errrors for missing mb_foo
# functions. See bug #532618.
RDEPEND="dev-lang/php:*[unicode]"

src_prepare() {
	default

	# Prepare the docs and examples for easy dodocing.
	rm docs/_config.yml || die
	mv -v demo examples || die
}

src_install() {
	insinto "/usr/share/php/${PN}"
	doins -r libs/*

	local DOCS=( CHANGELOG.md README.md SECURITY.md )

	use doc && dodoc -r docs/*
	use examples && dodoc -r examples
	einstalldocs
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog
	elog 'To use it in your scripts, include the Smarty.class.php file'
	elog "from the \"${PN}\" directory; for example,"
	elog
	elog "  require('${PN}/Smarty.class.php');"
	elog
	elog 'After that, the Smarty class will be available to you.'
}
