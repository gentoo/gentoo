# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Use native OS implementation of File::Spec from a subclass"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
