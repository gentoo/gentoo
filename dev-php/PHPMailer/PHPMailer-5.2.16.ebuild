# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Full-featured email creation and transfer class for PHP"
HOMEPAGE="https://github.com/PHPMailer/PHPMailer"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +examples test"

RDEPEND="dev-lang/php:*"
DEPEND="${RDEPEND}
	doc? ( dev-php/phpDocumentor )
	test? ( ${RDEPEND} dev-php/phpunit )"

# The test suite requires network access.
RESTRICT=test

src_compile(){
	if use doc; then
		phpdoc --filename="class.*.php" \
			   --target="./html" \
			   --cache-folder="${T}" \
			   --title="${PN}" \
			   --sourcecode \
			   --force \
			   --progressbar \
			   || die "failed to generate API documentation"
	fi
}

src_install(){
	insinto "/usr/share/php/${PN}"
	doins -r *.php language extras

	dodoc README.md changelog.md
	dodoc docs/*
	use examples && dodoc -r examples

	use doc && dodoc -r html/*
}

src_test(){
	cd test/ || die
	phpunit . || die "test suite failed"
}

pkg_postinst(){
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog "To use it in a script, require('${PN}/${PN}Autoload.php'),"
	elog "and then use the ${PN} class normally. Most of the examples in"
	elog "the documentation should work without further modification."
}
