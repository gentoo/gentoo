# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Adapt CGI.pm to the PSGI protocol"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/CGI-3.330.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.88
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.15-no-dot-inc.patch"
)
