# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TJENNESS
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Search for a file in an environment variable path"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
