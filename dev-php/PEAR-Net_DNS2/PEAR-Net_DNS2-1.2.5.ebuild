# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_DNS2/PEAR-Net_DNS2-1.2.5.ebuild,v 1.2 2014/08/10 20:52:06 slyfox Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Object-oriented PHP5 resolver library used to communicate with a DNS server"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[sockets]"
