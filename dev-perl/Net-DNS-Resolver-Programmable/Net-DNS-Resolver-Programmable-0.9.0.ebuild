# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BIGPRESH
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="programmable DNS resolver class for offline emulation of DNS"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	>=dev-perl/Net-DNS-0.690.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
