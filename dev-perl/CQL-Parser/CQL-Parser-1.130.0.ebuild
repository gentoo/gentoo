# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CQL-Parser/CQL-Parser-1.130.0.ebuild,v 1.1 2015/05/02 16:44:08 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=1.13
inherit perl-module

DESCRIPTION="compiles CQL strings into parse trees of Node subtypes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Accessor-0.100.0
	>=dev-perl/Clone-0.150.0
	>=dev-perl/String-Tokenizer-0.50.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do
