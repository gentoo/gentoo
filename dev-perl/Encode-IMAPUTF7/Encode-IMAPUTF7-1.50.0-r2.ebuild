# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PMAKHOLM
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Modification of UTF-7 encoding for IMAP"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Encode"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-NoWarnings
	)
"
