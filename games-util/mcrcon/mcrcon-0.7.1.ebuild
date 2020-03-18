# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Remote connection client for Minecraft servers"
HOMEPAGE="https://github.com/Tiiffi/mcrcon"
SRC_URI="https://github.com/Tiiffi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${LDFLAGS} -std=gnu99 -Wall -Wextra -Wpedantic"
}

src_install() {
	emake install PREFIX="${ED}/usr"
}
