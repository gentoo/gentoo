# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=6.07
inherit perl-module

DESCRIPTION="Class that represents an HTML form element"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=virtual/perl-Encode-2
	dev-perl/HTML-Parser
	>=dev-perl/HTTP-Message-6.30.0
	>=dev-perl/URI-1.100.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
