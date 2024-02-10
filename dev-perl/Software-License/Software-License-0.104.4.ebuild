# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.104004
inherit perl-module

DESCRIPTION="Packages that provide templated software licenses"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-Section
	virtual/perl-File-Spec
	virtual/perl-IO
	virtual/perl-Module-Load
	dev-perl/Text-Template
	virtual/perl-parent
"
BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Try-Tiny
	)
"
