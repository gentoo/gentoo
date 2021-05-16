# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.005
inherit perl-module

DESCRIPTION="export shared globs with Sub::Exporter collectors"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
# r: Scalar::Util -> Scalar-List-Utils
# r: strict, warnings -> perl
RDEPEND="
	dev-perl/Sub-Exporter
	virtual/perl-Scalar-List-Utils
"
# t: IPC::Open3 -> perl
# t: lib -> perl
# t: Test::More -> Test-Simple
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
