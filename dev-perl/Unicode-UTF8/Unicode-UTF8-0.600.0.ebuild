# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CHANSEN
MODULE_VERSION=0.60
inherit perl-module

DESCRIPTION="Encoding and decoding of UTF-8 encoding form"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=virtual/perl-Encode-1.980.100
		>=dev-perl/Test-Fatal-0.6.0
		>=virtual/perl-Test-Simple-0.470.0

		dev-perl/Test-Pod
		dev-perl/Taint-Runtime
		dev-perl/Variable-Magic
		dev-perl/Test-LeakTrace
	)
"

SRC_TEST=do
