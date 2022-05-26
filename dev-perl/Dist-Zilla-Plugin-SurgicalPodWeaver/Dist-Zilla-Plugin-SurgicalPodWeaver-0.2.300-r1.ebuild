# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.0023
inherit perl-module

DESCRIPTION="Surgically apply PodWeaver"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla-Plugin-PodWeaver
	dev-perl/Moose
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Most
	)
"
