# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NICOLAW
DIST_VERSION=1.44
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Simple interface to create and store data in RRD files"
SRC_URI+=" https://dev.gentoo.org/~kentnl/distfiles/${PN}-${DIST_VERSION}-patches-1.tar.xz"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-analyzer/rrdtool[perl]
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Deep-0.93.0
	)
"
PATCHES=( "${WORKDIR}/patches" )
