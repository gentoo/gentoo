# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Math_BigInteger/PEAR-Math_BigInteger-1.0.2.ebuild,v 1.4 2015/05/05 07:43:58 jer Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Pure-PHP arbitrary precision integer arithmetic library"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-5.3.0"
