# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/flowgrind/flowgrind-0.7.1.ebuild,v 1.1 2014/05/28 04:34:26 radhermit Exp $

EAPI=5

DESCRIPTION="Network performance measurement tool"
HOMEPAGE="http://flowgrind.net/ https://github.com/flowgrind/flowgrind/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gsl pcap"

RDEPEND="dev-libs/xmlrpc-c[abyss,curl]
	gsl? ( sci-libs/gsl )
	pcap? ( net-libs/libpcap )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable gsl) \
		$(use_enable pcap)
}
