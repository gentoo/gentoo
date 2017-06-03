# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=STEPHEN
MODULE_VERSION=1.124
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
		virtual/perl-autodie
		virtual/perl-Test-Simple
		dev-perl/Test-Most
	)
"

SRC_TEST="do parallel"
