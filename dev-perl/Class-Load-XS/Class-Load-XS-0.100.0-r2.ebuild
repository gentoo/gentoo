# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="XS implementation of parts of Class::Load"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-perl/Class-Load-0.200.0
	virtual/perl-XSLoader
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Module-Implementation-0.40.0
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		virtual/perl-version
	)
"
