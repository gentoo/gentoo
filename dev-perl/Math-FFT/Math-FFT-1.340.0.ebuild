# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.34
inherit perl-module

DESCRIPTION="Perl module to calculate Fast Fourier Transforms"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
		virtual/perl-parent
	)
"
