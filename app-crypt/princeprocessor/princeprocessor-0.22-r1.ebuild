# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Standalone password candidate generator using the PRINCE algorithm"
HOMEPAGE="https://github.com/hashcat/princeprocessor"
SRC_URI="https://github.com/hashcat/princeprocessor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	edo $(tc-getCC) -W -Wall -std=c99 ${CFLAGS} ${LDFLAGS} -DLINUX -o ${PN} pp.c mpz_int128.h
}

src_install() {
	dobin ${PN}
	dodoc ../{README.md,CHANGES}
	#install rules after hashcat is fixed
	#insinto /usr/share/hashcat
	#doins ../rules/*.rules
}
