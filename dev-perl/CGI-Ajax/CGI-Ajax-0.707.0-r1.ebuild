# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=0.707
DIST_AUTHOR=BPEDERSE
inherit perl-module

DESCRIPTION="a perl-specific system for writing Asynchronous web applications"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/CGI
	dev-perl/Class-Accessor
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"
