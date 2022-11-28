# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GRICHTER
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="Modules to parse C header files and create XS glue code"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-perl/Parse-RecDescent
	dev-perl/Tie-IxHash
"
BDEPEND="${RDEPEND}"
