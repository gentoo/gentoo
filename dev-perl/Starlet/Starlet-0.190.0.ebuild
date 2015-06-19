# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Starlet/Starlet-0.190.0.ebuild,v 1.1 2013/08/16 08:10:43 patrick Exp $

EAPI=5

MODULE_AUTHOR=KAZUHO
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="A simple, high-performance PSGI/Plack HTTP server"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parallel-Prefork-0.130.0
	>=dev-perl/Plack-0.992.0
	>=dev-perl/Server-Starter-0.60.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=dev-perl/Test-TCP-0.150.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST=do
