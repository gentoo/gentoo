# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.74
inherit perl-module

DESCRIPTION="Parse and Format DateTimes using Strptime"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/DateTime-1
	>=dev-perl/DateTime-Locale-1.50.0
	>=dev-perl/DateTime-TimeZone-2.90.0
	virtual/perl-Exporter
	>=dev-perl/Package-DeprecationManager-0.150.0
	dev-perl/Params-ValidationCompiler
	>=dev-perl/Specio-0.330.0
	dev-perl/Try-Tiny
	virtual/perl-parent
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
