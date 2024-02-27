# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Open DHCP Locator"
HOMEPAGE="https://odhcploc.sourceforge.io"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	# Don't clobber toolchain defaults
	sed -i -e 's:-Wp,-D_FORTIFY_SOURCE=2::' Makefile || die

	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.8
	dodoc AUTHORS
}
