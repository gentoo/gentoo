# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="easy to use web server"
SRC_URI="https://github.com/cesanta/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://code.google.com/p/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86 ~arm-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${P}/examples/web_server

src_prepare() {
	eapply_user
	sed -e "s|-g -O0 ||" -i Makefile || die
}

src_compile() {
	tc-export CC
	emake CFLAGS_EXTRA="${CFLAGS}" web_server
}

src_install() {
	newbin "${S}/web_server" "${PN}"
	dodoc ../../README.md
}
