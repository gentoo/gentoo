# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Genome-scale comparison of biological sequences"
HOMEPAGE="http://last.cbrc.jp/"
SRC_URI="http://last.cbrc.jp/archive/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	sed \
		-e 's:-o $@:$(LDFLAGS) -o $@:g' \
		-i src/makefile || die
}

src_compile() {
	emake \
		-e -C src \
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		STRICT="" || die
}

src_install() {
	dobin src/last{al,db,ex}
	exeinto /usr/share/${PN}/scripts
	doexe scripts/*
	dodoc doc/*.txt ChangeLog.txt README.txt
}
