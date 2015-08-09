# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TROCKIJ
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="A Monitor Perl Module"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 )" # GPL2+
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=net-analyzer/fping-2.2_beta1
	>=dev-perl/Convert-BER-1.31
	>=dev-perl/Net-Telnet-3.02
	>=dev-perl/Period-1.20"
DEPEND="${RDEPEND}"

mydoc="COPYING COPYRIGHT VERSION"
