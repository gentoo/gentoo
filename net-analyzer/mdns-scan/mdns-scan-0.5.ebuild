# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a tool for scanning for mDNS/DNS-SD published services"
HOMEPAGE="http://0pointer.de/lennart/projects/mdns-scan/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i "s#-Wall -W -g -O0 -pipe#${CFLAGS} ${LDFLAGS}#" Makefile
	sed -i "s#-o #${CFLAGS} ${LDFLAGS} -o #" Makefile
	default
}

src_install() {
	dodir /usr/bin
	default
}
