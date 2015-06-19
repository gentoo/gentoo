# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-ModInt/Math-ModInt-0.7.0.ebuild,v 1.2 2014/12/07 13:19:32 zlogene Exp $

EAPI=5

MODULE_AUTHOR="MHASCH"
MODULE_VERSION="0.007"

inherit perl-module

DESCRIPTION="modular integer arithmetic"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Math-BigInt-GMP"
