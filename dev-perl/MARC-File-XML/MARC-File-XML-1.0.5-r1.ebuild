# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GMCHARLT
inherit perl-module

DESCRIPTION="Work with MARC data encoded as XML"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/MARC-Charset-0.980.0
	>=dev-perl/MARC-Record-2.0.0
	>=dev-perl/XML-LibXML-1.660.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
