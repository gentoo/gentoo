# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BLILBURNE
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="Abstract document tree for Perl POD documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/IO-String
	virtual/perl-Scalar-List-Utils
	virtual/perl-File-Temp
	dev-perl/Pod-Parser
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"
