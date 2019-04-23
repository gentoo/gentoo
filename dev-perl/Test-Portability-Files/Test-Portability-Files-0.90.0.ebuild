# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ABRAXXA
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Check file names portability"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Temp-0.230.400
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.980.0
	)
"
src_prepare() {
	perl_rm_files t/release-*.t t/author-*.t
	perl-module_src_prepare
}
