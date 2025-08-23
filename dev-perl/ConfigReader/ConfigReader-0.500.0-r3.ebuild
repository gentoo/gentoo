# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AMW
DIST_VERSION=0.5
inherit perl-module

DESCRIPTION="Read directives from a configuration file"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

PATCHES=( "${FILESDIR}/${P}-makefile-tests.patch" )
