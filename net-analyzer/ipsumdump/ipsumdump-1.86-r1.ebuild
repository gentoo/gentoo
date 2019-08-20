# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple TCP/IP Dump summarizer/analyzer"
HOMEPAGE="http://read.seas.harvard.edu/~kohler/ipsumdump/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="the-Click-license"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ipv6 +nanotimestamp"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-libs/expat
	sys-apps/texinfo
	virtual/os-headers
"
DOCS=(
	NEWS.md
	README.md
)
PATCHES=(
	"${FILESDIR}"/${PN}-1.86-SIOCGSTAMP.patch
)

src_configure() {
	econf \
		$(use_enable ipv6 ip6) \
		$(use_enable nanotimestamp)
}
