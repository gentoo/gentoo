# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.56
inherit perl-module

DESCRIPTION="A colletion of List utilities missing from List::Util"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 s390 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Module-Implementation
	>=dev-perl/List-SomeUtils-XS-0.550.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Text-ParseWords
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.960.0
	)
"
