# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CFRETER
DIST_VERSION=1.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Perl bindings for Revision Control System"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-vcs/rcs"
DEPEND="${RDEPEND}"
