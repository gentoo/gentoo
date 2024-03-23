# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=${PN}-v
MY_P=${MY_PN}${PV}

DESCRIPTION="Prints watermark-like text on any PostScript document"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://www.antitachyon.com/download/${MY_P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-string.patch
	"${FILESDIR}"/${P}-Makefile-QA.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin psmark
	doman psmark.1
	dodoc README CHANGELOG
}
