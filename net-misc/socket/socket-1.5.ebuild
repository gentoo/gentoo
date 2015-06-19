# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/socket/socket-1.5.ebuild,v 1.1 2013/02/04 21:09:13 pinkbyte Exp $

EAPI=5

inherit base toolchain-funcs

DESCRIPTION="A shell-level interface to TCP sockets"
HOMEPAGE="http://www.jnickelsen.de/socket/"
SRC_URI="http://www.jnickelsen.de/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

IUSE="examples"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

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
