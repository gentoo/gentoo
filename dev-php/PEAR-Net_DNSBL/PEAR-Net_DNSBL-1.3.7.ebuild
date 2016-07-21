# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="DNSBL Checker"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 sparc x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-Cache_Lite-1.5.2-r1
	>=dev-php/PEAR-Net_CheckIP-1.1-r1
	>=dev-php/PEAR-HTTP_Request2-2.0.0
	>=dev-php/PEAR-Net_DNS-1.0.0"
