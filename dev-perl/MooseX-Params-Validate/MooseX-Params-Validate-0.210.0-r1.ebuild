# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="An extension of Params::Validate using Moose types"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Devel-Caller
	>=dev-perl/Moose-2.120.0
	>=dev-perl/Params-Validate-1.150.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
