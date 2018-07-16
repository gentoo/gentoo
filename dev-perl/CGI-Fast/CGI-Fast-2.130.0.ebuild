# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEEJO
DIST_VERSION=2.13
inherit perl-module

DESCRIPTION="CGI Interface for Fast CGI"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ppc ~ppc64 ~s390 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/CGI-4
	virtual/perl-Carp
	>=dev-perl/FCGI-0.670.0
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=( "t/006_changes.t" )
