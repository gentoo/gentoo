# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.002
inherit perl-module

DESCRIPTION="Dist::Build extension to use pkg-config"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/ExtUtils-Helpers
	dev-perl/PkgConfig
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build-Tiny
"
