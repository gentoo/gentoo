# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EINHVERFR
DIST_VERSION=0.092.0
inherit perl-module

DESCRIPTION="Encode characters for LaTeX formatting"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/HTML-Parser
	dev-perl/Pod-LaTeX
	dev-perl/Readonly
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Carp-Always
	)
"

src_test() {
	perl_rm_files t/9*.t
	perl-module_src_test
}
