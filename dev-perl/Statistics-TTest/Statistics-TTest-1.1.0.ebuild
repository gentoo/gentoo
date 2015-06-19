# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Statistics-TTest/Statistics-TTest-1.1.0.ebuild,v 1.2 2014/01/12 23:28:21 civil Exp $

EAPI="5"

MODULE_AUTHOR="YUNFANG"
MODULE_VERSION="1.1.0"

inherit perl-module

DESCRIPTION="module to compute the confidence interval"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/Statistics-Distributions-1.02
	>=dev-perl/Statistics-Descriptive-3.60.300"
