# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Full-featured email creation and transfer class for PHP"
HOMEPAGE="https://github.com/PHPMailer/PHPMailer"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples idn ssl"

# The ctype and filter extensions get used unconditionally, with no
# fallback and no "extension missing" exception. All of the other
# extensions are technically optional, depending on how you use
# PHPMailer and whether or not you're willing to settle for fallback
# implementations.
#
# The insane dependency string is to prevent the ctype and filter
# extensions from being provided by one version (i.e. slot) of PHP,
# while intl and unicode are provided by another.
RDEPEND="
	ssl? (
		idn?  ( dev-lang/php:*[ctype,filter,intl,ssl,unicode] )
		!idn? ( dev-lang/php:*[ctype,filter,ssl] )
	)
	!ssl? (
		idn?  ( dev-lang/php:*[ctype,filter,intl,unicode] )
		!idn? ( dev-lang/php:*[ctype,filter] )
	)"
DEPEND="${RDEPEND}
	doc? ( dev-php/phpDocumentor )"

src_compile() {
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

src_install() {
	# To help out the Composer kids, most of the documentation and
	# tests are missing from the release tarballs.
	insinto "/usr/share/php/${PN}"
	doins -r *.php language extras

	use examples && dodoc -r examples
	use doc && dodoc -r html/*
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog "To use it in a script, require('${PN}/${PN}Autoload.php'),"
	elog "and then use the ${PN} class normally. Most of the examples in"
	elog "the documentation should work without further modification."
}
