# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="Dynamic prerequisites in meta files"

SLOT="0"
KEYWORDS="~amd64 ~loong"

RDEPEND="
	dev-perl/CPAN-Meta-Requirements
	dev-perl/ExtUtils-Config
	dev-perl/ExtUtils-HasCompiler
"
