# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION='Returns the equivalent of ${^GLOBAL_PHASE} eq DESTRUCT for older perls'

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.11
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
