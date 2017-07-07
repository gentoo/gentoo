# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.008
inherit perl-module

DESCRIPTION="Add test failures if warnings are caught"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE="test"
LICENSE="Apache-2.0"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=virtual/perl-Test-Simple-0.860.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Capture-Tiny-0.120.0
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.960.0
	)
"
