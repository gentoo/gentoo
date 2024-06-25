# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=THOR
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="net-dns/libidn2:="
DEPEND="net-dns/libidn2:="
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.10.0
	)
"
