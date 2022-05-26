# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TROCKIJ
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="A Monitor Perl Module"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	>=net-analyzer/fping-2.2_beta1
	>=dev-perl/Convert-BER-1.310.0
	>=dev-perl/Net-Telnet-3.20.0
	>=dev-perl/Time-Period-1.200.0
"
BDEPEND="${RDEPEND}
"

mydoc="COPYING COPYRIGHT VERSION"
