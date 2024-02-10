# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Program to link two /dev/net/tun to form virtual ethernet"
HOMEPAGE="https://grumpf.hope-2000.org/"
SRC_URI="https://grumpf.hope-2000.org/${PN}.c -> ${P}.c"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

src_unpack() {
	cp "${DISTDIR}"/${P}.c ${P}.c || die
}

src_compile() {
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${P}.c
}

src_install() {
	dobin ${PN}
}
