# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Full-featured email creation and transfer class for PHP"
HOMEPAGE="https://github.com/PHPMailer/PHPMailer"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# To help out the Composer children, the tests and examples are missing
# from the release tarballs.
IUSE="idn ssl"

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

src_install() {
	# The PHPMailer class loads its language files
	# using a relative path, so we need to keep the "src" here.
	insinto "/usr/share/php/${PN}"
	doins -r language src

	dodoc README.md SECURITY.md
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog "Upstream no longer provides an autoloader, so you will need"
	elog "to include each source file (for example: PHPMailer.php,"
	elog "Exception.php,...) that you need."
}
