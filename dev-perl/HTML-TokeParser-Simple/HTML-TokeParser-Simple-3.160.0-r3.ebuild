# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OVID
DIST_VERSION=3.16
inherit perl-module

DESCRIPTION="Easy to use HTML::TokeParser interface"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND=">=dev-perl/HTML-Parser-3.25"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/Sub-Override
"
