# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.36
inherit perl-module

DESCRIPTION="A date and time object"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

CONFLICTS="
	!<=dev-perl/DateTime-Format-Mail-0.402.0
"
RDEPEND="
	${CONFLICTS}
	virtual/perl-Carp
	>=dev-perl/DateTime-Locale-1.50.0
	>=dev-perl/DateTime-TimeZone-2.0.0
	>=dev-perl/Dist-CheckConflicts-0.20.0
	>=dev-perl/Params-Validate-1.30.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Specio-0.180.0
	dev-perl/Try-Tiny
	virtual/perl-XSLoader
	>=dev-perl/namespace-autoclean-0.190.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-CPAN-Meta-Requirements
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-File-Spec
		virtual/perl-Storable
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Warnings-0.5.0
	)
"
