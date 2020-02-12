# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Poor man's web vulnerability scanner"
HOMEPAGE="http://gunzip.altervista.org/g.php?f=projects"
SRC_URI="http://gunzip.altervista.org/webfuzzer/webfuzzer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/devel
PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dodoc CHANGES README TODO
	dobin webfuzzer
}
