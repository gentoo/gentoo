# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/arptools/arptools-1.0.2.ebuild,v 1.5 2014/08/10 20:57:15 slyfox Exp $

EAPI=5

DESCRIPTION="a collection of libnet and libpcap based ARP utilities"
HOMEPAGE="http://www.burghardt.pl/wiki/software/arptools"
SRC_URI="http://www.burghardt.pl/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )
