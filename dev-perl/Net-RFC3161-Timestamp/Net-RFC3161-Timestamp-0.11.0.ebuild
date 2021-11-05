# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKHUETTEL
DIST_VERSION=0.011
inherit perl-module

DESCRIPTION="Utility functions to request RFC3161 timestamps"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Alien-OpenSSL
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/HTTP-Message
	dev-perl/LWP-Protocol-https
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
