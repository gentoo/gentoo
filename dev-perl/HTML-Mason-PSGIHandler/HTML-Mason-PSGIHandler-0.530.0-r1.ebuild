# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RUZ
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="PSGI handler for HTML::Mason"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/CGI-PSGI
	dev-perl/HTML-Mason
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Plack
		virtual/perl-Test-Simple
	)
"
