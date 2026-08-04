# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
inherit perl-module

DESCRIPTION="Modern module builder, author tools not included!"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-perl/ExtUtils-Builder
	dev-perl/ExtUtils-Builder-Compiler
"
