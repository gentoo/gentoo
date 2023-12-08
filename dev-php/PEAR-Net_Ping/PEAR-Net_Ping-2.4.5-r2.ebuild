# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="OS independent wrapper class for executing ping calls"
HOMEPAGE="https://pear.php.net/package/Net_Ping"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_install() {
	use examples && dodoc -r docs/examples

	insinto /usr/share/php/Net
	doins -r Ping.php
}
