# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="XS parsing/building of application/x-www-form-urlencoded"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=dev-perl/JSON-2
		>=virtual/perl-Test-Simple-0.980.0
	)
"
