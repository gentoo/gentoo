# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KASEI
DIST_VERSION=0.51
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Automated accessor generation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="dev-perl/Sub-Name"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
