# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Litstream is a lightweight and robust shoutcast-compatible streaming mp3 server"
HOMEPAGE="http://www.litestream.org/"
SRC_URI="http://litestream.org/litestream/${P/_rc/RC}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"

S="${WORKDIR}/${P/_rc/RC}"
PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin litestream literestream
	newbin source litestream-source
	newbin server litestream-server
	newbin client litestream-client

	einstalldocs
	dodoc ABOUT ACKNOWLEDGEMENTS CONTACT FILES MAKEITGO
}
