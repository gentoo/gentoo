# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="a collection of libnet and libpcap based ARP utilities"
HOMEPAGE="https://github.com/burghardt/arptools"
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
