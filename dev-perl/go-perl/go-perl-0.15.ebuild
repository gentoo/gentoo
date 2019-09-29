# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR="CMUNGALL"

inherit perl-module

DESCRIPTION="GO::Parser parses all GO files formats and types"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Data-Stag-0.11"
RDEPEND="${DEPEND}"
BDEPEND=""
