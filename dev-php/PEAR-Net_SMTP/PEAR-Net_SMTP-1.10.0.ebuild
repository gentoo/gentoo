# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A PHP implementation of the SMTP protocol"
HOMEPAGE="https://pear.php.net/package/Net_SMTP"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="examples sasl test"
DEPEND=""
RDEPEND="dev-lang/php:*
	dev-php/PEAR-Net_Socket
	dev-php/PEAR-PEAR
	sasl? ( dev-php/PEAR-Auth_SASL )"
BDEPEND="test? ( ${RDEPEND} )"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_P}"

src_install() {
	use examples && HTML_DOCS=( examples )
	php-pear-r2_src_install
}

src_test() {
	pear run-tests tests || die
}
