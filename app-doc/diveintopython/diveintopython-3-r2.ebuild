# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="'Dive Into Python' by Mark Pilgrim - Python 3"
HOMEPAGE="https://www.diveintopython3.net/"

SRC_URI="
	https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz
	https://dev.gentoo.org/~monsieurp/packages/${P}-pdf.tar.gz
"

LICENSE="CC-BY-SA-3.0"
SLOT="3"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"

src_install() {
	dodoc ${P}.pdf
	rm ${P}.pdf || die
	docinto html
	dodoc -r ./*
}
