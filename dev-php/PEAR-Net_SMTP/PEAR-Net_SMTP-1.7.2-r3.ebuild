# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A PHP implementation of the SMTP protocol"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="examples sasl"
DEPEND=""
RDEPEND="dev-lang/php:*
	dev-php/PEAR-Net_Socket
	dev-php/PEAR-PEAR
	sasl? ( dev-php/PEAR-Auth_SASL )"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc docs/guide.txt
	use examples && dodoc -r examples

	insinto /usr/share/php
	doins -r Net
}
