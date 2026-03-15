# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.103019
inherit perl-module

DESCRIPTION="Upload things to the CPAN"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"

RDEPEND="
	>=dev-perl/Getopt-Long-Descriptive-0.84.0
	dev-perl/HTTP-Message
	>=dev-perl/LWP-Protocol-https-1.0.0
	dev-perl/libwww-perl
	dev-perl/TermReadKey
"
BDEPEND="
	${RDEPEND}
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		>=virtual/perl-Test-Simple-0.960.0
	)
"
