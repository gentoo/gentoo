# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=MONGODB
MODULE_VERSION="v${PV}"

inherit perl-module

DESCRIPTION="Official MongoDB Driver for Perl"
SLOT="0"

KEYWORDS="~amd64"

LICENSE="Apache-2.0"
IUSE=test

RDEPEND="
	dev-perl/Authen-SCRAM
	virtual/perl-Carp
	dev-perl/Moose
	>=dev-perl/DateTime-0.780.0
	virtual/perl-Digest-MD5
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-IO
	virtual/perl-MIME-Base64
	dev-perl/Safe-Isa
	virtual/perl-Scalar-List-Utils
	dev-perl/Syntax-Keyword-Junction
	dev-perl/Throwable
	dev-perl/Tie-IxHash
	virtual/perl-Time-HiRes
	dev-perl/Try-Tiny
	virtual/perl-XSLoader
	dev-perl/boolean
	virtual/perl-if
	dev-perl/namespace-clean
"
DEPEND="${RDEPEND}
	>=dev-perl/Config-AutoConf-0.220.0
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Path-Tiny-0.52.0
	test? (
		virtual/perl-Data-Dumper
		dev-perl/DateTime-Tiny
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/JSON
		>=dev-perl/Test-Deep-0.111.0
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warn
		virtual/perl-bignum
	)
"
