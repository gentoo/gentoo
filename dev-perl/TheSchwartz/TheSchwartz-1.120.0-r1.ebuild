# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JFEARN
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="Reliable job queue"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Data-ObjectDriver-0.06"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"
PATCHES=( "${FILESDIR}/${PN}-1.12-no-dot-inc.patch" )
# Parallel tests fail due to database ordering issues
DIST_TEST="do"
