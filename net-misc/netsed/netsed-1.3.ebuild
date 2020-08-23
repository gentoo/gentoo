# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small tool for altering forwarded network data in real time"
HOMEPAGE="http://silicone.homelinux.org/projects/netsed/"
SRC_URI="http://silicone.homelinux.org/release/netsed/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin netsed
	dodoc NEWS README
}
