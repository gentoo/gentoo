# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Simple TCP/IP Dump summarizer/analyzer"
HOMEPAGE="http://read.seas.harvard.edu/~kohler/ipsumdump/"
SRC_URI="http://read.seas.harvard.edu/~kohler/ipsumdump/${P}.tar.gz"

LICENSE="the-Click-license"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ipv6 +nanotimestamp"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/expat
	sys-apps/texinfo"

src_configure() {
	econf $(use_enable ipv6 ip6) \
		$(use_enable nanotimestamp)
}
