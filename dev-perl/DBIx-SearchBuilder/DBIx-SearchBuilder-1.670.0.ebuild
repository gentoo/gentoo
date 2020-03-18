# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BPS
DIST_VERSION=1.67
DIST_EXAMPLES=("ex/*")
inherit perl-module

DESCRIPTION="Encapsulate SQL queries and rows in simple Perl objects"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Cache-Simple-TimedExpiry-0.210.0
	>=dev-perl/capitalization-0.30.0
	>=dev-perl/Class-ReturnValue-0.400.0
	dev-perl/Class-Accessor
	dev-perl/Clone
	dev-perl/DBI
	dev-perl/DBIx-DBSchema
	dev-perl/Want
	>=virtual/perl-Encode-1.990.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		>=virtual/perl-Test-Simple-0.520.0
		dev-perl/DBD-SQLite
		virtual/perl-File-Temp
	)
"

PATCHES=( "${FILESDIR}/${PN}"-1.66-no-dot-inc.patch )

src_prepare() {
	use test && perl_rm_files t/pod.t
	perl-module_src_prepare
}
