# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=0.05
DIST_EXAMPLES=("scripts/benchmark.pl")
inherit perl-module

DESCRIPTION="Just-in-time compiler for HTML::Template"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/HTML-Template-2.8
	dev-perl/Inline
	dev-perl/Inline-C
"
BDEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${P}-no-dot-inc.patch")
