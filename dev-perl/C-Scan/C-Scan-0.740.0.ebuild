# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HVDS
DIST_VERSION=0.74
inherit perl-module

DESCRIPTION="Scan C language files for easily recognized constructs"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Data-Flow"
DEPEND="${RDEPEND}"
