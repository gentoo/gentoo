# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DDICK
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="Provide non blocking randomness"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( t/pod.t )
