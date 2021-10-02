# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.009
DIST_AUTHOR=AMBA
inherit perl-module

KEYWORDS="~amd64 ~x86"
DESCRIPTION="Perl interface to the USB Test & Measurement (USBTMC) backend"
SLOT="0"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	dev-perl/Moose
	dev-perl/MooseX-Params-Validate
	dev-perl/USB-LibUSB
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
