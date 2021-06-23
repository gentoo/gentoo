# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NHORNE
DIST_VERSION=1.21
inherit perl-module

DESCRIPTION="Correctly case a person's name from UPERCASE or lowcase"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.700.0
	)
"

src_test() {
	perl_rm_files t/9{0,1,4,5,6}*.t
	perl-module_src_test
}
