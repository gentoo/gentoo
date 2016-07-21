# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DMAKI
DIST_VERSION=0.3105
inherit perl-module

DESCRIPTION="XML::RSS with XML::LibXML"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	virtual/perl-Encode
	dev-perl/UNIVERSAL-require
	>=dev-perl/XML-LibXML-1.660.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-CPAN-Meta
	test? (
		!minimal? (
			dev-perl/Test-Exception
			dev-perl/Test-Warn
		)
	)
"
