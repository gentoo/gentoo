# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Parse error messages from the perl interpreter"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-XSAccessor
	virtual/perl-File-Spec
	dev-perl/Pod-Parser
	>=dev-perl/Pod-POM-0.270.0
"

BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.59
	test? (
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.470.0
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.27-no-dot-inc.patch" )
