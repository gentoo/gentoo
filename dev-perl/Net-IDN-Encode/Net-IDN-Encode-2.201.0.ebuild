# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IDN-Encode/Net-IDN-Encode-2.201.0.ebuild,v 1.3 2015/06/13 22:28:49 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=2.201
inherit perl-module

DESCRIPTION="Internationalizing Domain Names in Applications (IDNA)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Unicode-Normalize
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST=do
