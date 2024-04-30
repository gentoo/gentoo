# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WaterVIS utility for glquake"
HOMEPAGE="https://vispatch.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/vispatch/${P}.tgz"
S="${WORKDIR}"/${P}/source

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		makefile || die

	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.txt
}
