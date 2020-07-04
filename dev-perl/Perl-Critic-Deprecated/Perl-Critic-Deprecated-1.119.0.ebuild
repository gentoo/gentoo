# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=THALJEF
DIST_VERSION=1.119
inherit perl-module

DESCRIPTION="Perl::Critic policies which have been superseded by others"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Perl-Critic-1.118.0
	dev-perl/Readonly
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (	virtual/perl-Test-Simple )
"
