# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Powerful and flexible message logging mechanism"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Module-Load
	virtual/perl-Params-Check
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
