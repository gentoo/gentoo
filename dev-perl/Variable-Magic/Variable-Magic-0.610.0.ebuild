# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=VPIT
DIST_VERSION=0.61
DIST_EXAMPLES=("samples/*")
inherit perl-module

DESCRIPTION="Associate user-defined magic to variables from Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ppc ~ppc64 x86 ~ppc-aix ~x86-fbsd ~x64-macos"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
