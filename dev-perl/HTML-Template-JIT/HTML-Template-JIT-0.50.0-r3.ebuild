# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=0.05
DIST_EXAMPLES=("scripts/benchmark.pl")
inherit perl-module

DESCRIPTION="a just-in-time compiler for HTML::Template"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTML-Template-2.8
	dev-perl/Inline
	dev-perl/Inline-C
"
BDEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${P}-no-dot-inc.patch")
