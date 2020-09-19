# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=YANICK
DIST_VERSION=0.2.5
inherit perl-module

DESCRIPTION="update the next version, semantic-wise"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/CPAN-Changes-0.200.0
	dev-perl/Dist-Zilla
	dev-perl/List-AllUtils
	dev-perl/Moose
	dev-perl/Perl-Version
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.2.5-no-V-in-test.patch"
)
