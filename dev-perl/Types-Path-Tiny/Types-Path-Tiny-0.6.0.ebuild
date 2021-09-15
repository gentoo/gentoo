# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Path::Tiny types and coercions for Moose and Moo"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Path-Tiny
	>=dev-perl/Type-Tiny-0.8.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-File-Temp-0.180.0
		dev-perl/File-pushd
		>=virtual/perl-Test-Simple-0.960.0
	)
"
