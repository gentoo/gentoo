# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DOC_PV="3.1.14"

DESCRIPTION="A template engine for PHP"
HOMEPAGE="http://www.smarty.net/"
SRC_URI="https://github.com/smarty-php/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://www.smarty.net/files/docs/manual-en.${DOC_PV}.zip )"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="doc? ( app-arch/unzip )"

# PHP unicode support is detected at runtime, and the cached templates
# that smarty generates depend on it. If, later on, PHP is reinstalled
# without unicode support, all of the previously-generated cached
# templates will begin to throw 500 errrors for missing mb_foo
# functions. See bug #532618.
RDEPEND="dev-lang/php:*[unicode]"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins -r libs/*

	local DOCS=( *.txt README README.md )
	local HTML_DOCS
	use doc && HTML_DOCS="${WORKDIR}/manual-en/"*
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
