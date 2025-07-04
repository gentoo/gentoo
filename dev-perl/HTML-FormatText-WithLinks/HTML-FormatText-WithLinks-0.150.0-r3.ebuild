# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STRUAN
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="HTML to text conversion with links as footnotes"

SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	>=dev-perl/HTML-Formatter-2
	dev-perl/HTML-Tree
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
"
