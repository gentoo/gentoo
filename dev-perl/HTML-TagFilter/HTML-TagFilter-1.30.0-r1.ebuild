# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=1.03
DIST_AUTHOR="WROSS"
inherit perl-module

DESCRIPTION="A fine-grained html-filter, xss-blocker and mailto-obfuscator"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/HTML-Parser
	dev-perl/URI
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${P}-no-dot-inc.patch" )
