# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"

DESCRIPTION="An API for talking to sieve (RFC 3028) servers"
HOMEPAGE="https://github.com/roundcube/${MY_PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="sasl"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-Net_Socket
	sasl? ( dev-php/PEAR-Auth_SASL )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	# Install into "Net" for backwards compatibility (that's where PEAR
	# used to put things).
	insinto /usr/share/php/Net
	doins Sieve.php
}
