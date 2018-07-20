# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=3.000
inherit perl-module

DESCRIPTION="Base class for Email Message Exchange"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-File-Spec-0.700.0
	virtual/perl-IO
	>=dev-perl/Mail-Message-3
	virtual/perl-Scalar-List-Utils
	virtual/perl-libnet
	!!<dev-perl/Mail-Box-3
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
