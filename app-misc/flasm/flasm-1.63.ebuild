# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator toolchain-funcs

MY_PV=$(delete_all_version_separators $(get_version_component_range 1-2))
DESCRIPTION="Command line assembler/disassembler of Flash ActionScript bytecode"
HOMEPAGE="http://www.nowrap.de/flasm.html"
SRC_URI="http://www.nowrap.de/download/flasm${MY_PV}src.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/gperf
	sys-devel/flex
	virtual/yacc
"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin flasm
	dodoc CHANGES.TXT
	dohtml flasm.html classic.css
}
