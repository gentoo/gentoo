# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Layer Four Traceroute (LFT) and WhoB"
HOMEPAGE="http://pwhois.org/lft/"
SRC_URI="http://pwhois.org/get/${P/0}.tar.gz"

LICENSE="VOSTROM"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
S=${WORKDIR}/${P/0}

DOCS=( CHANGELOG README TODO )

src_prepare() {
	sed -i -e 's:strip:true:g' Makefile.in || die
	sed -i \
		-e 's|_BSD_SOURCE|_DEFAULT_SOURCE|g' \
		configure config/acconfig.h.in || die
	default
}
