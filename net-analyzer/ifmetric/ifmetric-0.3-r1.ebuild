# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Linux tool for setting metrics of all IPv4 routes attached to a given network interface at once"
HOMEPAGE="http://0pointer.de/lennart/projects/ifmetric/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-kernel/linux-headers"

DOCS=( README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-ul.patch
}

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
