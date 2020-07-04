# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=FAYLAND
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="dzil plugin to generate README from POD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/Dist-Zilla-6.0.0
	dev-perl/IO-String
	dev-perl/Moose
	>=dev-perl/Path-Tiny-0.4.0
	>=dev-perl/Pod-Readme-1.2.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
