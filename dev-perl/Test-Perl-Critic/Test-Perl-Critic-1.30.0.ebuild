# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=THALJEF
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Use Perl::Critic in test programs"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/MCE-1.520.0
	>=dev-perl/Perl-Critic-1.105.0
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
"
