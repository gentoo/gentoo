# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHORNY
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Cubic Spline Interpolation of data"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Math-Derivative
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
