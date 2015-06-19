# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SNPP/Net-SNPP-1.170.0-r1.ebuild,v 1.1 2014/08/23 00:20:29 axs Exp $

EAPI=5

MODULE_AUTHOR=TOBEYA
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION="libnet SNPP component"

SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="virtual/perl-libnet"
