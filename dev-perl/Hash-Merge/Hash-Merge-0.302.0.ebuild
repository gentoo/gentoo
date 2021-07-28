# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HERMES
DIST_VERSION=0.302
inherit perl-module

DESCRIPTION="Merges arbitrarily deep hashes into a single hash"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Clone-Choose-0.8.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.900.0
		>=dev-perl/Clone-0.100.0
		dev-perl/Clone-PP
		virtual/perl-Storable
	)
"
