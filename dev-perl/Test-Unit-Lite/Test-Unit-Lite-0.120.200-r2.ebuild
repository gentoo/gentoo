# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DEXTER
DIST_VERSION=0.1202
inherit perl-module

DESCRIPTION="Unit testing without external dependencies"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="dev-perl/Module-Build"
