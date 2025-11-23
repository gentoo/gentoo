# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Use Perl::Critic in test programs"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/MCE-1.827.0
	>=dev-perl/Perl-Critic-1.105.0
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
"
