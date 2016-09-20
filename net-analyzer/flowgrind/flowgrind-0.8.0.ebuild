# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Network performance measurement tool"
HOMEPAGE="http://flowgrind.net/ https://github.com/flowgrind/flowgrind/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gsl pcap"

RDEPEND="
	dev-libs/xmlrpc-c[abyss,curl]
	gsl? ( sci-libs/gsl )
	pcap? ( net-libs/libpcap )
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with doc doxygen) \
		$(use_with gsl) \
		$(use_with pcap)
}

src_compile() {
	default

	use doc && emake html
}

src_install() {
	default

	use doc && dodoc -r doc/html
}
