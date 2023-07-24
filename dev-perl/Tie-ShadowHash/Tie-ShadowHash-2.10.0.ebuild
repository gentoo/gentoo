# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRA
DIST_VERSION=2.01
inherit perl-module

DESCRIPTION="Merge multiple data sources into a hash"

SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	>=dev-perl/Module-Build-0.280.0
"
