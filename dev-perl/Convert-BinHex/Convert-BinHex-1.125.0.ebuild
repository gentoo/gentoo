# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=STEPHEN
DIST_VERSION=1.125
inherit perl-module

DESCRIPTION="Extract data from Macintosh BinHex files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/File-Slurp
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
		dev-perl/Test-Most
		virtual/perl-autodie
	)
"
