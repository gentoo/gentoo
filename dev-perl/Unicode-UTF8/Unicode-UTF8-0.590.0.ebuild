# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-UTF8/Unicode-UTF8-0.590.0.ebuild,v 1.2 2013/09/09 09:47:39 pinkbyte Exp $

EAPI=5

MODULE_AUTHOR=CHANSEN
MODULE_VERSION=0.59
inherit perl-module

DESCRIPTION="Encoding and decoding of UTF-8 encoding form"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
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
