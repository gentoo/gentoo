# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/PEAR-/}"

DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
HOMEPAGE="https://pear.php.net/package/Net_LDAP2"
SRC_URI="https://download.pear.php.net/package/${MY_PN}-${PV}.tgz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND="dev-lang/php:*[ldap]
	dev-php/PEAR-PEAR"

src_install() {
	use examples && dodoc -r doc/examples
	dodoc doc/*.*
	insinto /usr/share/php
	doins -r Net
}
