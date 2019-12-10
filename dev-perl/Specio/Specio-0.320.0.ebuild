# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="Type constraints and coercions for Perl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Devel-StackTrace
	dev-perl/Eval-Closure
	virtual/perl-Exporter
	virtual/perl-IO
	dev-perl/MRO-Compat
	>=dev-perl/Role-Tiny-1.3.3
	>=virtual/perl-Scalar-List-Utils-1.330.0
	virtual/perl-Storable
	dev-perl/Test-Fatal
	>=virtual/perl-Test-Simple-0.960.0
	virtual/perl-parent
	>=virtual/perl-version-0.830.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Needs
	)
"
mydoc="TODO.md"
