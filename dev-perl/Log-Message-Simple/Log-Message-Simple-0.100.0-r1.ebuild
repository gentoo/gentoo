# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Simplified interface to Log::Message"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Log-Message
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
