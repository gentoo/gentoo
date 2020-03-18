# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.70
inherit perl-module

DESCRIPTION="Parse and Format DateTimes using Strptime"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~ppc-aix ~x64-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/DateTime-1
	>=dev-perl/DateTime-Locale-0.450.0
	>=dev-perl/DateTime-TimeZone-0.790.0
	virtual/perl-Exporter
	>=dev-perl/Package-DeprecationManager-0.150.0
	>=dev-perl/Params-Validate-1.200.0
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Fatal
		dev-perl/Test-Warnings
	)
"
