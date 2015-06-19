# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_Sieve/PEAR-Net_Sieve-1.3.3.ebuild,v 1.10 2015/02/28 14:07:36 ago Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides an API to talk to the timsieved server that comes with Cyrus IMAPd"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="sasl"

RDEPEND=">=dev-php/PEAR-Net_Socket-1.0.6-r1
	sasl? ( >=dev-php/PEAR-Auth_SASL-1.0 )
	"
