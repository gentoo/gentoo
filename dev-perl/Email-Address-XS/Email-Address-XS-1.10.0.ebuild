# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PALI
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Parse and format RFC 2822 email addresses and groups"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
