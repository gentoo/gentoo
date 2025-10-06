# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a tool for scanning for mDNS/DNS-SD published services"
HOMEPAGE="https://github.com/alteholz/mdns-scan"
COMMIT="9c307d81d82812e423664e4ebe135f429d995ac8"
SRC_URI="https://github.com/alteholz/mdns-scan/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i "s#-Wall -W -g -O0 -pipe#${CFLAGS}#" Makefile
	sed -i "s#-o #${LDFLAGS} -o #" Makefile
	default
}

src_install() {
	dodir /usr/bin
	default
}
