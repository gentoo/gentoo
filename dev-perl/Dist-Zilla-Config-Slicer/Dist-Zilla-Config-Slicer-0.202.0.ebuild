# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=0.202
inherit perl-module

DESCRIPTION="Config::MVP::Slicer customized for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-perl/Config-MVP-Slicer
	>=dev-perl/Dist-Zilla-4.0.0
	dev-perl/Moose
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.960.0
	)
"
