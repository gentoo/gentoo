# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

MY_P=${PN}.${PV/./}
DESCRIPTION="Pipe compressor/decompressor for ZPAQ"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="<app-arch/libzpaq-7"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_compile() {
	emake CXX="$(tc-getCXX)" LDLIBS=-lzpaq "${PN}"
}

src_install() {
	dobin ${PN}
}
