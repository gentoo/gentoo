# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.0023
inherit perl-module

DESCRIPTION="Surgically apply PodWeaver"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Dist-Zilla-Plugin-PodWeaver
	dev-perl/Moose
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Most
	)
"
