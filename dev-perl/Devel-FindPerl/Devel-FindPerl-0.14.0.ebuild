# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.014
inherit perl-module

DESCRIPTION="Find the path to your perl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
# r: Cwd -> File-Spec
# r: File::Basename -> perl
# r: File::Spec::Functions -> perl
# r: IPC::Open2 -> perl
# r: Scalar::Util -> Scalar-List-Utils
# r: strict, warnings -> perl
RDEPEND="
	!minimal? (
		>=dev-perl/ExtUtils-Config-0.7.0
	)
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	virtual/perl-Scalar-List-Utils
"
# t: Test::More -> Test-Simple
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
