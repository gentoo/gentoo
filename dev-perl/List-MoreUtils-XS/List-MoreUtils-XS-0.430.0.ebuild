# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=0.430
inherit perl-module

DESCRIPTION="Compiled List::MoreUtils functions"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# See XS.pm/LICENSE
LICENSE="Apache-2.0 || ( Artistic GPL-1+ )"

RDEPEND="
	!<dev-perl/List-MoreUtils-0.417.1
	>=virtual/perl-XSLoader-0.220.0
"
BDEPEND="${RDEPEND}
	virtual/perl-Carp
	>=dev-perl/Config-AutoConf-0.315.0
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-IPC-Cmd
	test? (
		virtual/perl-Storable
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.960.0
	)
"
