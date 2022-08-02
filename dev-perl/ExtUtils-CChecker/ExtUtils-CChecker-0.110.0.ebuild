# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Configure-time utilities for using C headers"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	virtual/perl-ExtUtils-CBuilder
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
