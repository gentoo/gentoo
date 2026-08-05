# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.028
inherit perl-module

DESCRIPTION="Modern module builder, author tools not included!"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/ExtUtils-Builder
	dev-perl/ExtUtils-Builder-Compiler
	dev-perl/ExtUtils-Config
	dev-perl/ExtUtils-Helpers
	dev-perl/ExtUtils-InstallPaths
"
BDEPEND="${RDEPEND}"
