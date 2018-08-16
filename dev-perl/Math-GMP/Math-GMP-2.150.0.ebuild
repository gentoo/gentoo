# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.15
inherit perl-module

DESCRIPTION="High speed arbitrary size integer math"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 hppa ~mips ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-libs/gmp:0
"
DEPEND="${RDEPEND}
	>=dev-perl/Devel-CheckLib-0.900.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
