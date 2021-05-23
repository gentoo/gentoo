# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.20
inherit perl-module

DESCRIPTION="High speed arbitrary size integer math"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-libs/gmp:0
"
DEPEND="${RDEPEND}
	>=dev-perl/Alien-GMP-1.80.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
