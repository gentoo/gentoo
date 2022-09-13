# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JAWNSY
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Perl interface to the ISAAC PRNG algorithm"

LICENSE="|| ( public-domain MIT Artistic Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

PDEPEND="
	dev-perl/Math-Random-ISAAC-XS
"
RDEPEND=""
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-NoWarnings
	)"
