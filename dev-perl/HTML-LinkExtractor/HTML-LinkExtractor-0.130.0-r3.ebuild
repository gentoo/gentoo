# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PODMASTER
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="A bare-bone HTML parser, similar to HTML::Parser"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-perl/HTML-Parser
	dev-perl/URI
"
BDEPEND="${RDEPEND}
"
