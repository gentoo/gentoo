# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.000005
inherit perl-module

DESCRIPTION="Roles. Like a nouvelle cuisine portion size slice of Moose"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ~ppc64 ~sparc x86 ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	!<dev-perl/Moo-0.9.14
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
