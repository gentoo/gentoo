# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Autoboxed wrappers for Native Perl datatypes"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	>=dev-perl/List-MoreUtils-0.70.0
	>=dev-perl/Moose-0.420.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Syntax-Keyword-Junction
	>=dev-perl/autobox-2.230.0
	dev-perl/namespace-autoclean
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
