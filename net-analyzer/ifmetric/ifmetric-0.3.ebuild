# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ifmetric/ifmetric-0.3.ebuild,v 1.6 2013/11/06 04:05:13 patrick Exp $

EAPI=4

DESCRIPTION="Linux tool for setting metrics of all IPv4 routes attached to a given network interface at once"
HOMEPAGE="http://0pointer.de/lennart/projects/ifmetric/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

# NOTE: this app is linux-only, virtual/os-headers therefore is incorrect
DEPEND="sys-kernel/linux-headers"
RDEPEND=""

DOCS=( README )

src_configure() {
	# man page and HTML are already generated
	econf \
		--disable-xmltoman \
		--disable-lynx
}

src_install() {
	default
	dohtml doc/README.html
}
