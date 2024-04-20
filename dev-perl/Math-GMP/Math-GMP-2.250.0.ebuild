# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.25
inherit perl-module

DESCRIPTION="High speed arbitrary size integer math"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc x86"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-libs/gmp:=
"
DEPEND="dev-libs/gmp:="
BDEPEND="
	${RDEPEND}
	>=dev-perl/Alien-GMP-1.80.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
	)
"
