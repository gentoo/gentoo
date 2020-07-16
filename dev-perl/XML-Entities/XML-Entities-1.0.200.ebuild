# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SIXTEASE
DIST_VERSION=1.0002
inherit perl-module

DESCRIPTION="Decode strings with XML entities"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp
	!minimal? (
		dev-perl/HTML-Parser
	)
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"

S="${WORKDIR}/${PN}" # Upstream doesn't tar it up with version in dir

PERL_RM_FILES=("bin/download-entities.pl") # maintainer tool
