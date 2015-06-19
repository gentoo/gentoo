# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-RBLClient/Net-RBLClient-0.500.0-r1.ebuild,v 1.1 2014/08/23 21:28:00 axs Exp $

EAPI=5

MODULE_AUTHOR=ABLUM
MODULE_VERSION=0.5
inherit perl-module

DESCRIPTION="Net::RBLClient - Queries multiple Realtime Blackhole Lists in parallel"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/perl-Time-HiRes
	dev-perl/Net-DNS"

S=${WORKDIR}/RBLCLient-${MODULE_VERSION} # second capitialized 'l' is deliberate
