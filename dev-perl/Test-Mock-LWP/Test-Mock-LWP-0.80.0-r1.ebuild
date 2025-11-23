# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LUKEC
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Mocks LWP::UserAgent"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Test-MockObject
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Install
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
"
