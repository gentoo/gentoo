# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Cisco-style (telnet) command-line interface library"

HOMEPAGE="http://sites.dparrish.com/libcli"
SRC_URI="https://github.com/dparrish/libcli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.9.7-libdir.patch" \
		"${FILESDIR}/${PN}-1.9.4-ldflags.patch"
}

src_compile() {
	emake OPTIM="" DEBUG="" \
		CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" \
		libdir="/usr/$(get_libdir)" install

	dobin clitest
	dodoc README
}
