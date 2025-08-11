# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DWHEELER
DIST_VERSION=3.37
inherit perl-module

DESCRIPTION="Stream TAP from pgTAP test scripts"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=dev-perl/Module-Build-0.420.900
"
