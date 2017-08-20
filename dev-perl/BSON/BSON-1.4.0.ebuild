# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONGODB
DIST_VERSION=v1.4.0
inherit perl-module

DESCRIPTION="BSON serialization and deserialization"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Digest-MD5
	virtual/perl-Exporter
	virtual/perl-Math-BigInt
	>=dev-perl/Moo-2.2.4
	virtual/perl-Scalar-List-Utils
	dev-perl/Tie-IxHash
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
	>=dev-perl/boolean-0.450.0
	dev-perl/namespace-clean
	virtual/perl-threads-shared
	virtual/perl-version
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		dev-perl/JSON-MaybeXS
		>=dev-perl/Path-Tiny-0.54.0
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.960.0
	)
"
