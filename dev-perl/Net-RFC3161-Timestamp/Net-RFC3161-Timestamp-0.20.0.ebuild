# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKHUETTEL
DIST_VERSION=0.020
inherit perl-module

DESCRIPTION="Utility functions to request RFC3161 timestamps"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-perl/Alien-OpenSSL
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Getopt-Long
	dev-perl/HTTP-Message
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Load
		virtual/perl-Test-Simple
	)
"
