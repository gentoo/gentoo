# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OVID
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Just roles. Nothing else"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~riscv x86"

BDEPEND="
	>=dev-perl/Module-Build-0.420.0
"
