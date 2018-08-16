# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=VPIT
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Lexically warn about using the indirect method call syntax"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Socket
	test? ( virtual/perl-Test-Simple )
"
