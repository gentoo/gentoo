# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JONASBN
DIST_VERSION=2.12
inherit perl-module

DESCRIPTION="test module to test/assert response times"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Error
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-1.302.111
	)
"
