# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.05
DIST_AUTHOR=AMBA
KEYWORDS="~amd64 ~x86"
inherit perl-module

DESCRIPTION="Perl interface to the libusb-1.0 API"

SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/libusb:1
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Moo
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
