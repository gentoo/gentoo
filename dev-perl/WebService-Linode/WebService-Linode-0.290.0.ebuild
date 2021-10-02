# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIKEGRB
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Perl interface to the Linode.com API"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/JSON
	 dev-perl/libwww-perl
	 dev-perl/LWP-Protocol-https
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
	dev-perl/Module-Build-Tiny
"
