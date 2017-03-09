# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KWILLIAMS
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Class-Container module for perl"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-perl/Params-Validate-0.24-r1
	>=virtual/perl-Scalar-List-Utils-1.08"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"
