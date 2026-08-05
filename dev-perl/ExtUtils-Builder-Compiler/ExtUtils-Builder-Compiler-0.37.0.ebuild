# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.037
inherit perl-module

DESCRIPTION="Interface around different compilers"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/ExtUtils-Builder
	dev-perl/ExtUtils-Config
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Differences
	)
"
