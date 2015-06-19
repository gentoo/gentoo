# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_LMTP/PEAR-Net_LMTP-1.0.2.ebuild,v 1.10 2014/08/10 20:52:40 slyfox Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides an implementation of the RFC2033 LMTP protocol"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-Net_Socket-1.0.6-r1"
