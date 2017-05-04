# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Combines many List::* utility modules in one bite-sized package"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
LICENSE="Artistic-2"
IUSE="test"

RDEPEND="
	>=dev-perl/List-SomeUtils-0.500.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/List-UtilsBy-0.100.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
