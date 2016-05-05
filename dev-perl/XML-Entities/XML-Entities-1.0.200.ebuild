# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SIXTEASE
DIST_VERSION=1.0002
inherit perl-module

DESCRIPTION="Decode strings with XML entities"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

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
