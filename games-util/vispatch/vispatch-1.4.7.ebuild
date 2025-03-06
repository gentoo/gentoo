# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="WaterVIS utility for GLQuake"
HOMEPAGE="https://vispatch.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/vispatch/${P}.tgz"
S="${WORKDIR}"/${P}/source

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		OPTIMIZATIONS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ../${PN}.txt
}
