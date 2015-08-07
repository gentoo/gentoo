# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Math_BigInteger/PEAR-Math_BigInteger-1.0.2.ebuild,v 1.7 2015/08/07 16:22:12 klausman Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Pure-PHP arbitrary precision integer arithmetic library"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-5.3.0"
