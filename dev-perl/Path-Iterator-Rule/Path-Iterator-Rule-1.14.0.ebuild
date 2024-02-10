# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.014
inherit perl-module

DESCRIPTION="Iterative, recursive file finder"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=dev-perl/Number-Compare-0.20.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Text-Glob
	dev-perl/Try-Tiny
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Temp
		dev-perl/File-pushd
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		>=dev-perl/Test-Filename-0.30.0
		>=virtual/perl-Test-Simple-0.920.0
		virtual/perl-parent
	)
"
