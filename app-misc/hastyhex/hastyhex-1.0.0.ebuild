# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A blazing fast hex dumper"
HOMEPAGE="https://github.com/skeeto/hastyhex"
SRC_URI="https://github.com/skeeto/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
