# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
