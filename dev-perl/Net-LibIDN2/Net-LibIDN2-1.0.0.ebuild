# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=THOR
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="net-dns/libidn2"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.10.0
	)
"
