# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEEJO
DIST_VERSION=2.16
inherit perl-module

DESCRIPTION="CGI Interface for Fast CGI"

SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/CGI-4
	virtual/perl-Carp
	>=dev-perl/FCGI-0.670.0
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( "t/006_changes.t" )
