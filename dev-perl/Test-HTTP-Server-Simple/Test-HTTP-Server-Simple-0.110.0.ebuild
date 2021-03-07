# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ALEXMV
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Test::More functions for HTTP::Server::Simple"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/HTTP-Server-Simple
	>=virtual/perl-Test-Simple-1.40.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
