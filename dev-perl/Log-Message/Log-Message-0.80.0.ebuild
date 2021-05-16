# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=BINGOS
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Powerful and flexible message logging mechanism"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Module-Load
	virtual/perl-Params-Check
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
