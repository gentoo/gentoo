# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=0.91
inherit perl-module

DESCRIPTION="Support XML::Compile related regression testing"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Log-Report-0.170.0
	>=dev-perl/Test-Deep-0.95.0
	>=virtual/perl-Test-Simple-0.540.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
