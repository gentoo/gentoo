# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.037
inherit perl-module

DESCRIPTION="Test for warnings and the lack of them"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="suggested"

RDEPEND="
	!<dev-perl/File-pushd-1.4.0
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Test-Simple
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		suggested? (
			>=dev-perl/CPAN-Meta-Check-0.11.0
		)
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.940.0
		virtual/perl-if
		virtual/perl-version
	)
"
