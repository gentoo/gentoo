# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MSTRAT
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="Get a locale specific string describing the span of a given duration"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build
	${RDEPEND}"

DIST_TEST="do"
