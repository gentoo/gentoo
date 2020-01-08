# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="A date and time object"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/DateTime-Locale-0.410.0
	>=dev-perl/DateTime-TimeZone-1.740.0
	>=dev-perl/Params-Validate-1.30.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Storable
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Warnings-0.5.0
	)
"
