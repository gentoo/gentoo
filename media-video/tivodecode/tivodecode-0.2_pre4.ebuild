# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

MY_P=${P/_/}
DESCRIPTION="TiVo File Decoder"
HOMEPAGE="https://tivodecode.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	lto-guarantee-fat
	default
}

src_compile(){
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	strip-lto-bytecode
}
