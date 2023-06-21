# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STEVEB
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Mock package, object and standard subroutines, with unit testing in mind"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Scalar-List-Utils
"
