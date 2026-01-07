# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=1.25
inherit perl-module

DESCRIPTION="Lookup the username on the remote end of a TCP/IP connection"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Socket
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
