# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.011
inherit perl-module

DESCRIPTION="Build.PL install path logic made easy"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/ExtUtils-Config-0.2.0
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Spec-0.830.0
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
