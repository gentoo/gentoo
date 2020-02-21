# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BINGOS
DIST_VERSION=0.80
inherit perl-module

DESCRIPTION="Generic archive extracting mechanism"

SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-IPC-Cmd
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Module-Load-Conditional
	virtual/perl-Params-Check
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
