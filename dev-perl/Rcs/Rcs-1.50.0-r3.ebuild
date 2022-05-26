# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CFRETER
DIST_VERSION=1.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Perl bindings for Revision Control System"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-vcs/rcs"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"
