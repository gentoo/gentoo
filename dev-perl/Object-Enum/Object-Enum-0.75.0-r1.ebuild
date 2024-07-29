# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JMMILLS
DIST_VERSION=0.075
inherit perl-module

DESCRIPTION="Replacement for if (\$foo eq 'bar')"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Sub-Install
	dev-perl/Sub-Exporter
	dev-perl/Class-Data-Inheritable
	dev-perl/Class-Accessor
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( "t/pod.t" "t/pod-coverage.t" "t/boilerplate.t" )
