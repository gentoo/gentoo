# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Shell-level interface to TCP sockets"
HOMEPAGE="https://w21.org/jnickelsen/socket/"
SRC_URI="https://w21.org/jnickelsen/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="examples"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin socket
	doman socket.1
	dodoc BLURB CHANGES README

	if use examples; then
		docinto examples
		dodoc scripts/*
	fi
}
