# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.000006
inherit perl-module

DESCRIPTION="Roles. Like a nouvelle cuisine portion size slice of Moose"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	!<dev-perl/Moo-0.9.14
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
