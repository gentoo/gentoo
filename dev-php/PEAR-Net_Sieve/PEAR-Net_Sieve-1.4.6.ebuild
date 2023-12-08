# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="An API for talking to sieve (RFC 3028) servers"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="sasl"

RDEPEND="dev-php/PEAR-Net_Socket
	sasl? ( dev-php/PEAR-Auth_SASL )"

src_install() {
	insinto /usr/share/php/Net
	doins Sieve.php
	php-pear-r2_install_packagexml
}
