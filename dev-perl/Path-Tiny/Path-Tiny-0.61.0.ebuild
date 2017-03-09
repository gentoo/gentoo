# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.061
inherit perl-module

DESCRIPTION="File path utility"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Unicode-UTF8-0.580.0
	virtual/perl-Carp
	>=virtual/perl-Digest-1.30.0
	>=virtual/perl-Digest-SHA-5.450.0
	virtual/perl-Exporter
	>=virtual/perl-File-Path-2.70.0
	>=virtual/perl-File-Spec-3.400.0
	>=virtual/perl-File-Temp-0.190.0
	virtual/perl-if
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Devel-Hide
		dev-perl/Test-Deep
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do
